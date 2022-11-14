//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

@_spi(AdyenInternal)
public struct AddressViewModelBuilderContext {
    public var countryCode: String
    public var isOptional: Bool
}

@_spi(AdyenInternal)
public protocol AddressViewModelBuilder {
    var scheme: [AddressFormScheme]? { get set }
    func build(context: AddressViewModelBuilderContext) -> AddressViewModel
}

@_spi(AdyenInternal)
public class DefaultAddressViewModelBuilder: AddressViewModelBuilder {

    public var scheme: [AddressFormScheme]?

    public init() {}

    // swiftlint:disable function_body_length
    @_spi(AdyenInternal)
    public func build(context: AddressViewModelBuilderContext) -> AddressViewModel {
        var viewModel = AddressViewModel(labels: [.city: .cityFieldTitle,
                                                  .houseNumberOrName: .houseNumberFieldTitle,
                                                  .street: .streetFieldTitle,
                                                  .stateOrProvince: .provinceOrTerritoryFieldTitle,
                                                  .postalCode: .postalCodeFieldTitle,
                                                  .apartment: .apartmentSuiteFieldTitle],
                                         placeholder: [.city: .cityFieldPlaceholder,
                                                       .houseNumberOrName: .houseNumberFieldPlaceholder,
                                                       .street: .streetFieldPlaceholder,
                                                       .stateOrProvince: .provinceOrTerritoryFieldPlaceholder,
                                                       .postalCode: .postalCodeFieldPlaceholder,
                                                       .apartment: .apartmentSuiteFieldPlaceholder],
                                         optionalFields: context.isOptional ? AddressField.allCases : [.apartment],
                                         scheme: AddressField.allCases.filter { $0 != .country }.map { .item($0) })
        self.scheme = viewModel.scheme
        switch context.countryCode {
        case "BR":
            viewModel.labels[.stateOrProvince] = .stateFieldTitle
            viewModel.placeholder[.stateOrProvince] = .selectStateOrProvinceFieldPlaceholder
        case "CA":
            viewModel.labels[.houseNumberOrName] = .apartmentSuiteFieldTitle
            viewModel.labels[.stateOrProvince] = .provinceOrTerritoryFieldTitle
            viewModel.labels[.street] = .addressFieldTitle
            viewModel.placeholder[.houseNumberOrName] = .apartmentSuiteFieldPlaceholder
            viewModel.placeholder[.stateOrProvince] = .provinceOrTerritoryFieldPlaceholder
            viewModel.placeholder[.street] = .addressFieldPlaceholder
            viewModel.optionalFields = context.isOptional ? AddressField.allCases : [.houseNumberOrName]
            viewModel.scheme = [.street, .houseNumberOrName, .city, .postalCode, .stateOrProvince].map { .item($0) }
            self.scheme = viewModel.scheme
        case "GB":
            viewModel.labels[.city] = .cityTownFieldTitle
            viewModel.placeholder[.city] = .cityTownFieldPlaceholder
            viewModel.scheme = [.houseNumberOrName, .street, .city, .postalCode].map { .item($0) }
            self.scheme = viewModel.scheme
        case "US":
            viewModel.labels[.postalCode] = .zipCodeFieldTitle
            viewModel.labels[.houseNumberOrName] = .apartmentSuiteFieldTitle
            viewModel.labels[.stateOrProvince] = .stateFieldTitle
            viewModel.labels[.street] = .addressFieldTitle
            viewModel.placeholder[.postalCode] = .zipCodeFieldPlaceholder
            viewModel.placeholder[.houseNumberOrName] = .apartmentSuiteFieldPlaceholder
            viewModel.placeholder[.stateOrProvince] = .selectStateFieldPlaceholder
            viewModel.placeholder[.street] = .addressFieldPlaceholder
            viewModel.optionalFields = context.isOptional ? AddressField.allCases : [.houseNumberOrName]
            viewModel.scheme = [.item(.street),
                                .item(.houseNumberOrName),
                                .item(.city),
                                .split(.stateOrProvince, .postalCode)]
            self.scheme = viewModel.scheme
        default:
            break
        }

        return viewModel
    }
    // swiftlint:enable function_body_length explicit_acl
}
