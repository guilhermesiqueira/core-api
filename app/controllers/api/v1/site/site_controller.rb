module Api
  module V1
    module Site
      class SiteController < ApplicationController
        def non_profits
          @non_profits = NonProfit.where(status: :active).last(3)
          render json: SiteNonProfitsBlueprint.render(@non_profits, language: params[:language])
        end
      end
    end
  end
end