//
// Copyright (c) 2020 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

/// An item for plain text input
/// :nodoc:
public final class FormTextInputItem: FormTextItem {

    /// :nodoc:
    public override init(style: FormTextItemStyle = .init()) {
        super.init(style: style)
    }
        
    /// :nodoc:
    override public func build(with builder: FormItemViewBuilder) -> AnyFormItemView {
        builder.build(with: self)
    }
    
}
