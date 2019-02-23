module Pod
  class Installer
    class UserProjectIntegrator
      class TargetIntegrator
        # Configures an user target to use the CocoaPods xcconfigs which allow
        # lo link against the Pods.
        #
        class XCConfigIntegrator
          # Integrates the user target.
          #
          # @param  [Target::AggregateTarget] pod_bundle
          #         The Pods bundle.
          #
          # @param  [Array<PBXNativeTarget>] targets
          #         The native targets associated which should be integrated
          #         with the Pod bundle.
          #
          def self.integrate(pod_bundle, targets)
            targets.each do |target|
              target.build_configurations.each do |config|
                set_target_xcconfig(pod_bundle, target, config)
              end
            end
          end

          private

          # @!group Integration steps
          #-------------------------------------------------------------------#

          # Creates a file reference to the xcconfig generated by
          # CocoaPods (if needed) and sets it as the base configuration of
          # build configuration of the user target.
          #
          # @param  [Target::AggregateTarget] pod_bundle
          #         The Pods bundle.
          #
          # @param  [PBXNativeTarget] target
          #         The native target.
          #
          # @param  [Xcodeproj::XCBuildConfiguration] config
          #         The build configuration.
          #
          def self.set_target_xcconfig(pod_bundle, target, config)
            file_ref = create_xcconfig_ref(pod_bundle, config)
            path = file_ref.path

            existing = config.base_configuration_reference

            if existing && existing != file_ref
              if existing.real_path.to_path.start_with?(pod_bundle.sandbox.root.to_path << '/')
                config.base_configuration_reference = file_ref
              elsif !xcconfig_includes_target_xcconfig?(config.base_configuration_reference, path)
                unless existing_config_is_identical_to_pod_config?(existing.real_path, pod_bundle.xcconfig_path(config.name))
                  UI.warn 'CocoaPods did not set the base configuration of your ' \
                  'project because your project already has a custom ' \
                  'config set. In order for CocoaPods integration to work at ' \
                  'all, please either set the base configurations of the target ' \
                  "`#{target.name}` to `#{path}` or include the `#{path}` in your " \
                  "build configuration (#{UI.path(existing.real_path)})."
                end
              end
            elsif config.base_configuration_reference.nil? || file_ref.nil?
              config.base_configuration_reference = file_ref
            end
          end

          private

          # @!group Private helpers
          #-------------------------------------------------------------------#

          # Prints a warning informing the user that a build configuration of
          # the integrated target is overriding the CocoaPods build settings.
          #
          # @param  [Target::AggregateTarget] pod_bundle
          #         The Pods bundle.
          #
          # @param  [XcodeProj::PBXNativeTarget] target
          #         The native target.
          #
          # @param  [Xcodeproj::XCBuildConfiguration] config
          #         The build configuration.
          #
          # @param  [String] key
          #         The key of the overridden build setting.
          #
          def self.print_override_warning(pod_bundle, target, config, key)
            actions = [
              'Use the `$(inherited)` flag, or',
              'Remove the build settings from the target.',
            ]
            message = "The `#{target.name} [#{config.name}]` " \
              "target overrides the `#{key}` build setting defined in " \
              "`#{pod_bundle.pod_bundle.xcconfig_relative_path(config.name)}'. " \
              'This can lead to problems with the CocoaPods installation'
            UI.warn(message, actions)
          end

          # Naively checks to see if a given PBXFileReference imports a given
          # path.
          #
          # @param  [PBXFileReference] base_config_ref
          #         A file reference to an `.xcconfig` file.
          #
          # @param  [String] target_config_path
          #         The path to check for.
          #
          SILENCE_WARNINGS_STRING = '// @COCOAPODS_SILENCE_WARNINGS@ //'
          def self.xcconfig_includes_target_xcconfig?(base_config_ref, target_config_path)
            return unless base_config_ref && base_config_ref.real_path.file?
            regex = %r{
              ^(
                (\s*                                  # Possible, but unlikely, space before include statement
                  \#include\s+                        # Include statement
                  ['"]                                # Open quote
                  (.*\/)?                             # Possible prefix to path
                  #{Regexp.quote(target_config_path)} # The path should end in the target_config_path
                  ['"]                                # Close quote
                )
                |
                (#{Regexp.quote(SILENCE_WARNINGS_STRING)}) # Token to treat xcconfig as good and silence pod install warnings
              )
            }x
            base_config_ref.real_path.readlines.find { |line| line =~ regex }
          end

          # Checks to see if the config files at two paths exist and are identical
          #
          # @param  The existing config path
          #
          # @param  The pod config path
          #
          def self.existing_config_is_identical_to_pod_config?(existing_config_path, pod_config_path)
            existing_config_path.file? && (!pod_config_path.file? || FileUtils.compare_file(existing_config_path, pod_config_path))
          end

          # Creates a file reference to the xcconfig generated by
          # CocoaPods (if needed).
          # If the Pods group not exists, create the group and set
          # the location to the `Pods` directory.
          # If the file reference exists, the location is different
          # with the xcconfig's path and the symlink target paths
          # are different, we will update the location.
          #
          # @param  [Target::AggregateTarget] pod_bundle
          #         The Pods bundle.
          #
          # @param  [Xcodeproj::XCBuildConfiguration] config
          #         The build configuration.
          #
          # @return [PBXFileReference] the xcconfig reference.
          #
          def self.create_xcconfig_ref(pod_bundle, config)
            # Xcode root group's path is absolute, we must get the relative path of the sandbox to the user project
            group_path = pod_bundle.relative_pods_root_path
            group = config.project['Pods'] || config.project.new_group('Pods', group_path)

            # support user custom paths of Pods group and xcconfigs files.
            group_path = Pathname.new(group.real_path)
            xcconfig_path = Pathname.new(pod_bundle.xcconfig_path(config.name))
            path = xcconfig_path.relative_path_from(group_path)

            filename = path.basename.to_s
            file_ref = group.files.find { |f| f.display_name == filename }
            if file_ref && file_ref.path != path
              file_ref_path = Pathname.new(file_ref.real_path)
              if !file_ref_path.exist? || !xcconfig_path.exist? || file_ref_path.realpath != xcconfig_path.realpath
                file_ref.path = path.to_s
              end
            end

            file_ref || group.new_file(path.to_s)
          end
        end
      end
    end
  end
end
