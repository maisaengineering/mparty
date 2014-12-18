class CsrAbility
  include CanCan::Ability

  def initialize user
    if user.has_spree_role?(:csr)
      can :manage, Spree::Order
      can :manage, Spree::Product
      can :manage, Spree::User do |resource|
        resource.has_spree_role?(:user)
      end
      cannot :destroy, Spree::User

      can :manage, Spree::Shipment
      cannot :update, Spree::Shipment
      cannot :resend, Spree::Order
      can :manage, Spree::Shipment::ManifestItem
      cannot :split, Spree::Shipment::ManifestItem
      can :manage, Spree::ShippingMethod
      can :manage, Spree::ShippingRate
      can :manage, Spree::Address
      can :manage, Spree::StateChange
      can :manage, Spree::Payment
      can :manage, Spree::LineItem
      can :manage, Spree::ReturnAuthorization
      can :manage, Spree::Adjustment
      can :manage, Spree::Variant
      can :manage, Spree::PaymentMethod
      can :manage, Spree::InventoryUnit
      can :manage, Spree::OptionValue
    end
  end
end