class PurchasesController < ApplicationController
  before_action :set_public_key, only: [:index, :create]
  before_action :move_to_index, only: [:index, :create]
  before_action :authenticate_user!, only: [:index,:create]

  def index
    @purchase_address = PurchaseAddress.new
  end

  def create
    @purchase_address = PurchaseAddress.new(purchase_params)
    if @purchase_address.valid?
      pay_item
      @purchase_address.save
      return redirect_to root_path
    else
      render 'index', status: :unprocessable_entity
    end
  end

    private

    def purchase_params
      params.require(:purchase_address).permit(:postal_code, :prefecture, :city, :addresses, :building, :phone_number, :purchase_id).merge(token: params[:token],item_id: params[:item_id], user_id: current_user.id)
    end

    def pay_item
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # 自身のPAY.JPテスト秘密鍵を記述しましょう
      item = Item.find(params[:item_id])
      Payjp::Charge.create(
        amount: item.price,  # 商品の値段
        card: purchase_params[:token],    # カードトークン
        currency: 'jpy'                 # 通貨の種類（日本円）
      )
    end

    def set_public_key
      gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
    end

    def move_to_index
      @item = Item.find(params[:item_id])
      if @item.purchase.present?
        redirect_to root_path
      elsif user_signed_in? && current_user == @item.user
        redirect_to root_path
      end
    end
end