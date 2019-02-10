//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public final class ObjectAssociation<T: Any> {
    
    // MARK: - Public -
    
    /// Initializes an associated object.
    ///
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        
        self.policy = policy
    }
    
    /// Accesses associated object.
    ///
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: Any) -> T? {
        
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
    
    // MARK: - Private -

    private let policy: objc_AssociationPolicy
    
}
