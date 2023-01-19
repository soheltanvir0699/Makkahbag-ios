//
//  DataModel.swift
//  MakkahBag
//
//  Created by appleguru on 30/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation

class StoredProperty {
    static var AllCountryName = [String]()
    static var AllCountrycode = [String]()

    static var Gender = "M"
    static var countryId = [String]()
    static var countryCode = [String]()
    static var dropDownIndex:Int?
    static var resetCode: Int?
    static var resetEmail: String?
}

struct CountryResponse: Codable {
    let countries: [Countries]
    let message: String
}

struct Countries:Codable {
    let id: Int
    let tele_code: String
    let name_fr: String
    let code:String?
    enum CodingKeys: String, CodingKey {
           case name_fr = "name"
           case id
           case tele_code
           case code
       }
}

struct ApiSuccessfulMessage: Codable {
    let message: String
    let data:token
}
struct token: Codable {
    let access_token:String
    let user_info: UserInfo
}
struct UserInfo: Codable {
    let email:String
    let fname:String?
    let lname:String?
    let gender:String?
    let mobileno:String?
    let country:String?
}
struct UpdateInfo: Codable {
    let user:UserInfo
}

struct ApiMessage: Codable {
    let message: String
    let success: Bool
}

struct ResetPassword: Codable {
    let message: String
    let data: Data1
}
struct Data1:Codable {
    let code: Int
}

struct CategoryData: Codable {
    let message: String
    let category_list: [CategoryList]
}

struct CategoryList: Codable {
    let id: Int
    let category_name_en: String
}

struct CategoryDataList: Codable {
    let product_list: ProductList
    let message: String
}

struct ProductList:Codable {
    let data: [DataDetails]
    let next_page_url:String?
}

struct DataDetails:Codable {
    let id:Int?
    let cat_id:String
    let pro_heading_en:String
    let pro_description_en:String
    let imageName:String
    let currentprice: String
    let oldprice:String?
    let star:String?
}

struct GetAllAddress: Codable {
    let message:String
    let user: [UserDetails]
}
struct removeData:Codable {
    let message:String
    let address:[UserDetails]
}
struct UserDetails: Codable {
    let id: Int
    let user_id: String
    let first_name: String
    let last_name: String
    let address: String?
    let city:String?
    let country_original_code: String?
    let street: String?
    let building: String?
    let mobile_number: String?
    let location_type: String?
    let veri_code: String?
    let state: String?
    let zipcode: String?
    let country_code: String?
    let country: String?
}

struct DashboardData: Codable {
    let success:Bool
    let message:String
    let hajj_time:String
    var banner_list:[BannerAllData]
    let bag_list:[BagListAllData]
    var category_list:[CategoryAllData]
}
struct BannerAllData:Codable {
    let id:Int?
    let banner: String?
    let heading_en: String?
    let button_align_en:String
}
struct BagListAllData:Codable {
    let id: Int?
    let cat_id: String?
    let pro_heading_en: String?
    let imageName: String?
    let currentprice: String?
}
struct CategoryAllData:Codable {
    let id:Int?
    let category_name_en:String?
}

struct wishData: Codable {
    let message:String?
    let wish_list: [wishListData]
}

struct wishListData:Codable {
    let id : Int?
    let user_id: String?
    let product_id: String?
    let imageName:String?
    let pro_heading_en:String?
    let current_price: String?
    let old_price:String?
    let reviews: Review?
}

struct Review:Codable {
    let star: String?
}

struct ShoppingData:Codable {
    let message: String?
    let total_discount: Double?
    let gift_card_discount: Double?
    let wallet_usages: Double?
    let coupon_discount: Double?
    let total_price:Double?
    let cart_count:Int?
    let cart_list:[CartList]
}

struct CartList: Codable {
    let id : Int?
    let user_id:String?
    let name:String?
    let product_id:String?
    let price:String?
    let quantity:String?
    let imageName:String?
    let old_price:String?
    let reviews: shopReview?
//    let discount:String?
    let star: String?
    let product:Product?
}
struct shopReview: Codable {
    let star:String?
}
struct Product :Codable{
    let id: Int?
    let cat_id:String?
    let pro_heading_en:String?
}

struct ShopData:Codable {
    let success:Bool
    let message: String?
    let shop_list:ShopList
}

struct ShopList:Codable {
    let data:[ShopDataList]
    let next_page_url:String?
}
struct ShopDataList:Codable {
    let id:Int?
    let cat_id:String?
    let pro_heading_en:String?
    let imageName:String?
    let currentprice:String?
    let oldprice:String?
    let review_count:Int
    let star:String?
}
struct SingleProduct:Codable {
    let success:Bool
    let review_count: Int?
    let product: SingleProductDetails
    let reviews:[SingleProductReview]?
    let star:String?
}

struct SingleProductDetails:Codable {
    let id:Int?
    let cat_id:String?
    let pro_heading_en:String?
    let pro_description_en:String?
    let imageName:String?
    let basic_bag:String?
    let oldprice:String?
    let currentprice:String?
    let cat_name:String?
    let created_at:String?
    let men_or_women:String?
    let review_star:String?
}

struct SingleProductReview:Codable {
    let review_name:String?
    let product_description:String?
    let review_star:String?
    let created_at:String?
}

struct GiftCardType:Codable {
    let success:Bool
    let message:String
    let list:[List]
}
struct List:Codable {
    let id:Int?
    let attachment:String?
    let card_name_en:String?
}

struct RecentSearch:Codable {
    let items:[String]?
}

struct OrderList:Codable {
    let message:String
    let order_list:Order
}

struct Order:Codable {
    let data:[OrderData]
}
struct OrderData:Codable {
    let id: Int?
    let customer_id:String?
    let total_price:String?
    let status:String?
    let updated_at:String?
}

struct orderDetailsApi:Codable {
    let message:String
    let order:[OrderDetailsData]
}
struct OrderDetailsData:Codable {
    let product_name:String?
    let total_price:String?
    let imageName:String?
    let quantity:String?
}

struct CountrySuccess: Codable {
    let alpha2Code:String?
}
