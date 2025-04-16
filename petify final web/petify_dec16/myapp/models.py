from django.db import models

# Create your models here.
class Login(models.Model):
    username=models.CharField(max_length=100)
    password = models.CharField(max_length=100)
    type = models.CharField(max_length=100)

class User(models.Model):
    username = models.CharField(max_length=100)
    email= models.CharField(max_length=100)
    phone_no = models.BigIntegerField()
    place= models.CharField(max_length=100)
    dob = models.DateField()
    gender = models.CharField(max_length=100)
    LOGIN = models.ForeignKey(Login, on_delete=models.CASCADE)
    photo = models.CharField(max_length=100)
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    pincode = models.CharField(max_length=100)

class Pet_shop(models.Model):
    shopname = models.CharField(max_length=100)
    place = models.CharField(max_length=100)
    post= models.CharField(max_length=100)
    phone_no = models.BigIntegerField()
    LOGIN = models.ForeignKey(Login,on_delete=models.CASCADE)
    email= models.CharField(max_length=100)
    photo = models.CharField(max_length=100)
    status = models.CharField(max_length=100)

class Delivery_boy(models.Model):
    name = models.CharField(max_length=100)
    phone_no = models.BigIntegerField()
    bike_no = models.CharField(max_length=20)
    bike_details = models.CharField(max_length=100)
    LOGIN = models.ForeignKey(Login, on_delete=models.CASCADE)
    photo = models.CharField(max_length=100)
    email = models.CharField(max_length=100)

class Review(models.Model):
    review= models.CharField(max_length=100)
    rating = models.CharField(max_length=100)
    date = models.DateField()
    USER = models.ForeignKey(User, on_delete=models.CASCADE)

class Pet(models.Model):
    photo= models.CharField(max_length=100)
    breed = models.CharField(max_length=100)
    age = models.BigIntegerField()
    description = models.CharField(max_length=100)
    price= models.BigIntegerField()
    LOGIN = models.ForeignKey(Login, on_delete=models.CASCADE)
    gender = models.CharField(max_length=100)
    type = models.CharField(max_length=100,default='')
    addtype = models.CharField(max_length=100,default='')


# class Sell_And_Adopt_Pet(models.Model):
#     photo= models.CharField(max_length=100)
#     breed = models.CharField(max_length=100)
#     age = models.BigIntegerField()
#     description = models.CharField(max_length=100)
#     price= models.BigIntegerField()
#     LOGIN = models.ForeignKey(Login, on_delete=models.CASCADE)
#     gender = models.CharField(max_length=100)
#     type = models.CharField(max_length=100,default='')
#     addtype = models.CharField(max_length=100,default='')







class Pet_products(models.Model):
    product_name = models.CharField(max_length=100)
    photo= models.CharField(max_length=100)
    description = models.CharField(max_length=100)
    price= models.BigIntegerField()
    SHOPNAME = models.ForeignKey(Pet_shop, on_delete=models.CASCADE)
    type = models.CharField(max_length=100,default='')





class Pet_Review(models.Model):
    review= models.CharField(max_length=100)
    rating = models.CharField(max_length=100)
    date = models.DateField()
    PET = models.ForeignKey(Pet, on_delete=models.CASCADE)
    USER = models.ForeignKey(User, on_delete=models.CASCADE,default=1)

class Disease(models.Model):
    disease_name= models.CharField(max_length=100)
    image= models.CharField(max_length=100)
    description= models.CharField(max_length=100)
    SHOPNAME = models.ForeignKey(Pet_shop, on_delete=models.CASCADE)
    remedy = models.CharField(max_length=100)

class Chat(models.Model):
    date = models.DateField()
    time = models.TimeField()
    FROMID= models.ForeignKey(Login,on_delete=models.CASCADE,related_name="from_id")
    TOID = models.ForeignKey(Login,on_delete=models.CASCADE,related_name="to_id")
    message = models.CharField(max_length=100)

class Order_Main(models.Model):
    date = models.DateField()
    status = models.CharField(max_length=100)
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    SHOPNAME = models.ForeignKey(Pet_shop, on_delete=models.CASCADE)
    amount = models.CharField(max_length=100)

class Order_Sub(models.Model):
    ORDER_MAIN = models.ForeignKey(Order_Main, on_delete=models.CASCADE)
    PET_PRODUCTS = models.ForeignKey(Pet_products, on_delete=models.CASCADE,default='')
    quantity = models.BigIntegerField()

class Grooming(models.Model):
    grooming_name = models.CharField(max_length=100)
    grooming_price = models.BigIntegerField()
    package_details = models.CharField(max_length=100)
    SHOPNAME = models.ForeignKey(Pet_shop, on_delete=models.CASCADE)

class Assign_Deliery_boy(models.Model):
    DELIVERY_BOY=models.ForeignKey(Delivery_boy,on_delete=models.CASCADE)
    ORDER_MAIN = models.ForeignKey(Order_Main, on_delete=models.CASCADE)
    date = models.DateField()
    status = models.CharField(max_length=100)

class Payment(models.Model):
    status = models.CharField(max_length=100)
    ORDER_MAIN = models.ForeignKey(Order_Main, on_delete=models.CASCADE)
    amount= models.CharField(max_length=100)
    USER = models.ForeignKey(User,on_delete=models.CASCADE)
    date = models.DateField()



class Pet_Order_Main(models.Model):
    date = models.DateField()
    status = models.CharField(max_length=100)
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    SHOPNAME = models.ForeignKey(Pet_shop, on_delete=models.CASCADE)
    amount = models.CharField(max_length=100)

class Pet_Order_Sub(models.Model):
    PET_ORDER_MAIN = models.ForeignKey(Pet_Order_Main, on_delete=models.CASCADE)
    PET = models.ForeignKey(Pet, on_delete=models.CASCADE)
    quantity = models.BigIntegerField()

class Grooming_Request(models.Model):
    GROOMING = models.ForeignKey(Grooming, on_delete=models.CASCADE)
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    date = models.DateField()
    status = models.CharField(max_length=100)
    paystatus = models.CharField(max_length=100)

class Pet_Payment(models.Model):
    status = models.CharField(max_length=100)
    PET_ORDER_MAIN = models.ForeignKey(Pet_Order_Main, on_delete=models.CASCADE)
    amount = models.CharField(max_length=100)
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    date = models.DateField()


class groom_Payment(models.Model):
    status = models.CharField(max_length=100)
    amount = models.CharField(max_length=100)
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    GROOMING_REQUEST= models.ForeignKey(Grooming_Request,on_delete=models.CASCADE)
    date = models.DateField()




class Pet_assign_Delivery_boy(models.Model):
    DELIVERY_BOY=models.ForeignKey(Delivery_boy,on_delete=models.CASCADE)
    ORDER_MAIN = models.ForeignKey(Pet_Order_Main, on_delete=models.CASCADE)
    date = models.DateField()
    status = models.CharField(max_length=100)



class Pet_Cart(models.Model):
    PET=models.ForeignKey(Pet,on_delete=models.CASCADE)
    USER=models.ForeignKey(User,on_delete=models.CASCADE)
    Quantity=models.CharField(max_length=100)


class Products_Cart(models.Model):
    PET_PRODUCTS=models.ForeignKey(Pet_products,on_delete=models.CASCADE)
    USER=models.ForeignKey(User,on_delete=models.CASCADE)
    Quantity=models.CharField(max_length=100)



class Vets(models.Model):
      Clinic=models.CharField(max_length=100)
      Location=models.CharField(max_length=100)
      photo = models.CharField(max_length=100)
      Latitude=models.CharField(max_length=100)
      Longitude=models.CharField(max_length=100)
      Phone_Number=models.CharField(max_length=100)
      Email=models.CharField(max_length=100)















