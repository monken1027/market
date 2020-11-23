module ProductsHelper

    #画像1取得
    def image1_url(product)
        if product.image1.blank?
            "https://dummyimage.com/200x200/000/fff"
        else
            product.image1.url
        end
    end
    
    #画像2取得
    def image2_url(product)
        if product.image2.blank?
            "https://dummyimage.com/200x200/000/fff"
        else
            product.image2.url
        end
    end
    #画像3取得
    def image3_url(product)
        if product.image3.blank?
            "https://dummyimage.com/200x200/000/fff"
        else
            product.image3.url
        end
    end

    #手数料計算
    def calc_fee(product)
        fee = 0.1
        product.price * fee
    end
    #販売利益計算
    def calc_profit(product)
        product.price - calc_fee(product)
    end

    #statusが1(売り切れ)であればtrue
    def product_sold?(product)
        product.status == "sold"
    end
    
    #カテゴリーリストのセット
    def set_categories
        @categories = Category.all.order(:display_order)
    end

end
