# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StuffSwap.Repo.insert!(%StuffSwap.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias StuffSwap.Repo
alias StuffSwap.Types.Category
alias StuffSwap.Subtypes.Subcategory

cat1 = Repo.insert!(%Category{title: "Tutoring", pic_uri: "https://www.marcellintechnicalcollege.com.au/wp-content/uploads/2017/08/best_9b050071fdbac0b857d6_b4a511b78341445cc483ddfe795d8895.jpg"})
Repo.insert!(%Subcategory{title: "Coding", category_id: cat1.id, pic_uri: "http://www.designlagoon.com/wp-content/uploads/2014/12/photodune-907221-css3-code-m.jpg"})
Repo.insert!(%Subcategory{title: "Art", category_id: cat1.id, pic_uri: "https://images7.alphacoders.com/680/680980.jpg"})
Repo.insert!(%Subcategory{title: "Foreign Languages", category_id: cat1.id, pic_uri: "http://ndebted.com/wp-content/uploads/2016/07/learning-foreign-languages.jpg"})
Repo.insert!(%Subcategory{title: "Misc", category_id: cat1.id, pic_uri: "http://www.discounthairtapes.com/images/categories/303.jpg"})

cat2 = Repo.insert!(%Category{title: "Accessory", pic_uri: "http://orriv.com/wp-content/uploads/accessories-1024x1024.jpg"})
Repo.insert!(%Subcategory{title: "Jewellery", category_id: cat2.id, pic_uri: "http://www.seacaef.org/wp-content/uploads/2012/07/sparkle_jewellery.jpg"})
Repo.insert!(%Subcategory{title: "Handmade", category_id: cat2.id, pic_uri: "http://st.gdefon.com/wallpapers_original/s/337112_predmety_-raznoe_-kreativ_-xend-mejd_-hand-made_2583x1620_(www.GdeFon.ru).jpg"})
Repo.insert!(%Subcategory{title: "Misc", category_id: cat2.id, pic_uri: "http://www.discounthairtapes.com/images/categories/303.jpg"})

cat3 = Repo.insert!(%Category{title: "Transport", pic_uri: "https://static9.depositphotos.com/1441191/1232/v/950/depositphotos_12323441-stock-illustration-means-of-transport.jpg"})
Repo.insert!(%Subcategory{title: "Cars", category_id: cat3.id, pic_uri: "http://mojmalnews.com/wp-content/uploads/2017/08/supersport-cars-hd-15-super-sport-cars.jpg"})
Repo.insert!(%Subcategory{title: "Bikes", category_id: cat3.id, pic_uri: "https://www.fc-moto.de/WebRoot/FCMotoDB/Shops/10207048/5076/D422/DC0C/C019/3FDB/3E70/5055/4BE6/Shoei_gt_air_schwarz_brillant.jpg"})
Repo.insert!(%Subcategory{title: "Bicycles", category_id: cat3.id, pic_uri: "http://icyclebc.com/wp-content/uploads/2016/06/pine-mountain-1-1024x591.jpg"})
Repo.insert!(%Subcategory{title: "Misc", category_id: cat3.id, pic_uri: "http://www.discounthairtapes.com/images/categories/303.jpg"})

cat4 = Repo.insert!(%Category{title: "Furniture", pic_uri: "http://mebeli.boraborabg.com/userfiles/categoryimages/original_image_632fc03333d31bfef072da2f412f50a9.jpg"})
Repo.insert!(%Subcategory{title: "For Kitchen", category_id: cat4.id, pic_uri: "http://www.home-furniture.org/wp-content/uploads/2015/06/11053-small-kitchen-islands-with-seating.jpg"})
Repo.insert!(%Subcategory{title: "For Bedroom", category_id: cat4.id, pic_uri: "http://bedroomdesigncatalog.com/wp-content/uploads/2012/11/Dark-Cherry-Bedroom-Furniture-Theme-Ideas.jpg"})
Repo.insert!(%Subcategory{title: "For Drawing Room", category_id: cat4.id, pic_uri: "http://haammss.com/daut/as/f/i/inspiring-living-room-theaters-with-white-wall-paint-color-ideas-furnished-twin-sofa-and-black-table-on-the-beautiful-floori_best-colors-to-use-with-a-white-sofa_apartment_interior-design-apartment-sm.jpg"})
Repo.insert!(%Subcategory{title: "Misc", category_id: cat4.id, pic_uri: "http://www.discounthairtapes.com/images/categories/303.jpg"})

cat5 = Repo.insert!(%Category{title: "Clothes", pic_uri: "http://www.jiechuangdz.com/data/out/25/541610.png"})
Repo.insert!(%Subcategory{title: "T-shirts/Sweaters/Jackets", category_id: cat5.id, pic_uri: "http://www.bennevisclothing.com/WebRoot/BT/Shops/BT3129/4D94/D056/B98F/D4B5/6ACA/0A0C/05E8/FEFB/Baseball_Jacket_Red_Front.jpg"})
Repo.insert!(%Subcategory{title: "Trousers/Skirts", category_id: cat5.id, pic_uri: "http://images.esellerpro.com/2713/I/154/17/Untitled-1.jpg"})
Repo.insert!(%Subcategory{title: "Shoes", category_id: cat5.id, pic_uri: "http://cdn.playbuzz.com/cdn/027c7610-64dc-438a-81fa-475d8162a334/e940a902-c778-475b-9e84-999f2d9aa766.jpg"})
Repo.insert!(%Subcategory{title: "Misc", category_id: cat5.id, pic_uri: "http://www.discounthairtapes.com/images/categories/303.jpg"})

cat6 = Repo.insert!(%Category{title: "Craft", pic_uri: "https://www.vimercatimeda.com/blog/wp-content/uploads/2016/08/vim-intaglio010.jpg"})
Repo.insert!(%Subcategory{title: "Repair/Construction", category_id: cat6.id, pic_uri: "http://piscopoplumbing.com/wp-content/uploads/2013/02/Residential-Pipe-Repair.png"})
Repo.insert!(%Subcategory{title: "Gardening", category_id: cat6.id, pic_uri: "https://www.webliststore.in/uploads/post-ad/280417050436get-fit-by-gardening.jpg"})
Repo.insert!(%Subcategory{title: "Misc", category_id: cat6.id, pic_uri: "http://www.discounthairtapes.com/images/categories/303.jpg"})

cat7 = Repo.insert!(%Category{title: "Equipment", pic_uri: "http://www.paystarfinancial.com/wp-content/uploads/2017/12/imagegroup.jpg"})
Repo.insert!(%Subcategory{title: "Audio", category_id: cat7.id, pic_uri: "http://www.adeptapple.ru/assets/images/products/25835/9d1899210574c2138c6385d9b13388fd.jpg"})
Repo.insert!(%Subcategory{title: "Video", category_id: cat7.id, pic_uri: "http://4.bp.blogspot.com/-frjZk6hO4XY/ThJ6j4C0_yI/AAAAAAAAAU8/RNNz3mUKtOU/s1600/camera-e-acessorios-hdsrl1.jpg"})
Repo.insert!(%Subcategory{title: "For Hiking", category_id: cat7.id, pic_uri: "https://st2.depositphotos.com/2804585/7811/v/380/depositphotos_78110392-stock-illustration-vector-illustration-with-equipments-for.jpg"})
Repo.insert!(%Subcategory{title: "For Construction", category_id: cat7.id, pic_uri: "https://media.gettyimages.com/photos/tools-picture-id145053595?b=1&k=6&m=145053595&s=612x612&w=0&h=qikoT_qzZIza-b9LAP5gNkbl13DcUGCXZIJn-eVjncA="})
Repo.insert!(%Subcategory{title: "Misc", category_id: cat7.id, pic_uri: "http://www.discounthairtapes.com/images/categories/303.jpg"})