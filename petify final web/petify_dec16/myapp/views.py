import base64
from datetime import datetime

from django.core.files.storage import FileSystemStorage
from django.core.mail import send_mail
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render

# Create your views here.
# admin
from myapp.models import *
from petify1 import settings


def login_get(request):
    return render(request,"loginindex.html")

def login_post(request):
    username=request.POST['textfield']
    password=request.POST['textfield2']
    lg=Login.objects.filter(username=username,password=password)
    if lg.exists():
        lg1=Login.objects.get(username=username,password=password)
        request.session['lid']=lg1.id
        if lg1.type == 'admin':
            return HttpResponse("<script>alert('login success');window.location='/myapp/adminhome/'</script>")
        if lg1.type == 'petshop':
            return HttpResponse("<script>alert('login success');window.location='/myapp/petshophome/'</script>")
        else:
            return HttpResponse("<script>alert('invalid username or password');window.location='/myapp/login_get/'</script>")

    else:
        return HttpResponse("<script>alert('not found');window.location='/myapp/login_get/'</script>")


def adminhome(request):
    return render(request,'admin/adminindex.html')


def changepass_get(request):
    return render(request, "admin/deliveryboypass.html")

def changepass_post(request):
    currentpassword=request.POST['textfield']
    newpassword=request.POST['textfield2']
    confirmpassword=request.POST['textfield3']
    return HttpResponse("OK")


def addpetshop_get (request):
    return render(request, "admin/managepetshopadd.html")

def addpetshop_post(request):
    shopname=request.POST['textfield']
    place=request.POST['textfield2']
    post=request.POST['textfield3']
    phoneno=request.POST['textfield4']
    email=request.POST['textfield5']
    photo=request.FILES['fileField']

    date=datetime.now().strftime('%Y%m%d-%H%M%S')+".jpg"
    f=FileSystemStorage()
    f.save(date,photo)
    path=f.url(date)

    y=Login()
    y.username=email
    import random
    y.password=random.randint(0000,9999)
    y.type='petshop'
    y.save()

    x=Pet_shop()
    x.shopname=shopname
    x.place=place
    x.post=post
    x.phone_no=phoneno
    x.email=email
    x.photo=path
    x.LOGIN=y
    x.save()
    return HttpResponse("<script>alert('success');window.location='/myapp/adminhome/'</script>")


def viewpetshop_get (request):
    x=Pet_shop.objects.all()
    return render(request, "admin/managepetshopview.html",{'data':x})


def viewpetshop_post (request):
    shopname = request.POST['textfield']
    x = Pet_shop.objects.filter(shopname__icontains=shopname)
    return render(request, "admin/managepetshopview.html", {'data': x})


def editpetshop_get (request,id):
    r=Pet_shop.objects.get(id=id)
    return render(request, "admin/managepetshopedit.html",{'data':r})

def editpetshop_post (request):
    shopname = request.POST['textfield5']
    place = request.POST['textfield']
    post = request.POST['textfield2']
    phoneno = request.POST['textfield3']
    email = request.POST['textfield4']
    id=request.POST['id']

    x = Pet_shop.objects.get(id=id)

    if 'fileField' in request.FILES:
        photo = request.FILES['fileField']
        date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
        f = FileSystemStorage()
        f.save(date, photo)
        path = f.url(date)
        x.photo = path
        x.save()

    x.shopname = shopname
    x.place = place
    x.post = post
    x.phone_no = phoneno
    x.email = email
    x.save()
    return HttpResponse("<script>alert('success');window.location='/myapp/Viewpetshop/'</script>")


def deletepetshop_get (request,id):
    Pet_shop.objects.get(LOGIN=id).delete()
    Login.objects.get(id=id).delete()
    return HttpResponse("<script>alert('deleted');window.location='/myapp/Viewpetshop/'</script>")






def adddeliveryboy_get (request):
    return render(request, "admin/DeliveryBoyAdd.html")

def adddeliveryboy_post (request):
    name=request.POST['textfield']
    phoneno = request.POST['textfield2']
    bikeno= request.POST['textfield3']
    bikedetails= request.POST['textfield4']
    photo=request.FILES['fileField']
    email=request.POST['textfield6']

    date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
    f = FileSystemStorage()
    f.save(date, photo)
    path = f.url(date)

    y=Login()
    y.username=email
    import random
    y.password=random.randint(0000,9999)
    y.type='deliveryboy'
    y.save()

    x = Delivery_boy()
    x.name = name
    x.bike_no=bikeno
    x.bike_details=bikedetails

    x.phone_no = phoneno
    x.email = email
    x.photo = path
    x.LOGIN = y
    x.save()
    return HttpResponse("<script>alert('success');window.location='/myapp/adminhome/'</script>")



def adminViewdeliveryboy (request):
    x = Delivery_boy.objects.all()
    return render(request, "admin/DeliveryBoyView.html",{'data': x})


def Viewdeliveryboy_post (request):
    name = request.POST['textfield']
    x = Delivery_boy.objects.filter(name__icontains=name)
    return render(request, "admin/DeliveryBoyView.html", {'data': x})


def editdeliveryboy_get (request,id):
    r=Delivery_boy.objects.get(id=id)
    return render(request, "admin/deliveryboyedit.html",{'data':r})

def editdeliveryboy_post (request):
    name = request.POST['textfield']
    phoneno = request.POST['textfield2']
    bikeno = request.POST['textfield3']
    bikedetails = request.POST['textfield4']
    email = request.POST['textfield6']
    id=request.POST['id']
    x = Delivery_boy.objects.get(id=id)

    if 'fileField' in request.FILES:
        photo = request.FILES['fileField']

        date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
        f = FileSystemStorage()
        f.save(date, photo)
        path = f.url(date)
        x.photo = path
        x.save()

    x.name = name
    x.bike_no = bikeno
    x.bike_details = bikedetails

    x.phone_no = phoneno
    x.email = email
    x.save()
    return HttpResponse("<script>alert('success');window.location='/myapp/adminhome/'</script>")


def deletedeliveryboy_get (request,id):
    Delivery_boy.objects.get(LOGIN=id).delete()
    Login.objects.get(id=id).delete()
    return HttpResponse("<script>alert('deleted');window.location='/myapp/adminViewdeliveryboy/'</script>")


def deletedeliveryboy_post (request):
    return HttpResponse("Deleted")



def reviewdeliveryboy_get (request):
    x=Review.objects.all()
    return render(request, "admin/DeliveryBoyReview.html",{'data':x})

def reviewdeliveryboy_post (request):

    fdate= request.POST['from']
    tdate = request.POST['to']
    x = Review.objects.filter(date__range=[fdate,tdate])
    return render(request, "admin/DeliveryBoyReview.html", {'data': x})


# pet shop


def petshophome(request):
    return render(request,'pet shop/shopindex.html')




def changepasspetshop_get (request):
    return render(request, "admin/deliveryboypass.html")

def changepasspetshop_post(request):
    currentpassword=request.POST['textfield']
    newpassword=request.POST['textfield2']
    confirmpassword=request.POST['textfield3']
    ch=Login.objects.filter(id=request.session['lid'],password=currentpassword)
    if ch.exists():
        Login.objects.get(id=request.session['lid'],password=currentpassword)
        if newpassword==confirmpassword:
            Login.objects.filter(id=request.session['lid']).update(password=confirmpassword)
            return HttpResponse("<script>alert('successfully updated');window.location='/myapp/Login/'</script>")
        else:
            return HttpResponse("<script>alert('password missmatched');window.location='/myapp/Changepassdb/'</script>")
    else:
        return HttpResponse(
            "<script>alert('check current password');window.location='/myapp/Changepassdb/'</script>")


############################################################################

def addpet_get (request):
    return render(request, "pet shop/managepetadd.html")

def addpet_post (request):
    photo=request.FILES['fileField']
    breed=request.POST['textfield']
    age = request.POST['textfield2']
    Description = request.POST['textarea']
    price = request.POST['textfield3']
    gender = request.POST['textfield5']
    type = request.POST['textfield6']



    date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
    f = FileSystemStorage()
    f.save(date, photo)
    path = f.url(date)



    x = Pet()
    x.photo = path
    x.breed = breed
    x.age = age
    x.description = Description
    x.price = price
    x.LOGIN=Login.objects.get(id=request.session['lid'])
    x.gender = gender
    x.type=type
    x.addtype='shop'
    x.save()

    return HttpResponse("<script>alert('Added Successfully');window.location='/myapp/Viewpet/'</script>")



def editpet_get (request,id):
    data=Pet.objects.get(id=id)
    return render(request, "pet shop/managepetedit.html",{"data":data})

def editpet_post (request):
    breed = request.POST['textfield']
    age = request.POST['textfield2']
    Description = request.POST['textarea']
    price = request.POST['textfield3']
    gender = request.POST['textfield5']
    id = request.POST['id']
    type = request.POST['textfield6']


    x = Pet.objects.get(id=id)
    if "fileField" in request.FILES:
        photo = request.FILES['fileField']
        date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
        f = FileSystemStorage()
        f.save(date, photo)
        path = f.url(date)
        x.photo = path
        x.save()
    x.breed = breed
    x.age = age
    x.description = Description
    x.price = price
    x.gender = gender
    x.type=type
    x.save()
    return HttpResponse("<script>alert('Edited Successfully');window.location='/myapp/Viewpet/'</script>")


def viewpet_get (request):
    data=Pet.objects.all()
    return render(request, "pet shop/managepetview.html",{"data":data})

def viewpet_post (request):
    search = request.POST['textfield6']
    return HttpResponse("ok")


def addpet_products_get (request):
    return render(request, "pet shop/manageproductadd.html")

def addpet_products_post (request):
    product_name = request.POST['textfield']
    photo=request.FILES['fileField']
    Description = request.POST['textarea']
    price = request.POST['textfield3']

    type = request.POST['textfield6']



    date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
    f = FileSystemStorage()
    f.save(date, photo)
    path = f.url(date)



    x = Pet_products()
    x.product_name = product_name
    x.photo = path
    x.description = Description
    x.price = price
    x.SHOPNAME=Pet_shop.objects.get(LOGIN_id=request.session['lid'])
    x.type=type
    x.save()

    return HttpResponse("<script>alert('Added Successfully');window.location='/myapp/Viewpetproducts/'</script>")



def editpet_products_get (request,id):
    request.session['pid']=id
    data=Pet_products.objects.get(id=id)
    return render(request, "pet shop/manageproductedit.html",{"data":data})

def editpet_products_post (request):
    product_name = request.POST['textfield']
    Description = request.POST['textarea']
    price = request.POST['textfield3']

    type = request.POST['textfield6']




    x = Pet_products.objects.get(id=request.session['pid'])
    if "fileField" in request.FILES:
        photo = request.FILES['fileField']
        date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
        f = FileSystemStorage()
        f.save(date, photo)
        path = f.url(date)
        x.photo = path
        x.save()
    x.description = Description
    x.price = price
    x.product_name = product_name
    x.type=type
    x.save()
    return HttpResponse("<script>alert('Edited Successfully');window.location='/myapp/Viewpetproducts/'</script>")


def Viewpetproducts (request):
    data=Pet_products.objects.all()
    return render(request, "pet shop/manageproductview.html",{"data":data})

def Viewpetproducts_post (request):
    search = request.POST['textfield6']
    return HttpResponse("ok")



def deletepet_get(request,id):
    Pet.objects.filter(id=id).delete()
    return HttpResponse("<script>alert('Deleted Successfully');window.location='/myapp/Viewpet/'</script>")

def deletepetproduct_get(request,id):
    Pet_products.objects.filter(id=id).delete()
    return HttpResponse("<script>alert('Deleted Successfully');window.location='/myapp/Viewpetproducts/'</script>")


def deletepet_post (request):
    return HttpResponse("deleted")

def adddiseasepet_get (request):
    return render(request, "pet shop/adddiesease.html")

def adddiseasepet_post (request):
    diseasename= request.POST['textfield']
    image= request.FILES['fileField']
    Description = request.POST['textarea']
    remedy= request.POST['textfield2']

    date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
    f = FileSystemStorage()
    f.save(date, image)
    path = f.url(date)

    x = Disease()
    x.disease_name = diseasename
    x.image = path
    x.description = Description
    x.SHOPNAME = Pet_shop.objects.get(LOGIN_id=request.session['lid'])
    x.remedy = remedy
    x.save()

    return HttpResponse("<script>alert('Added Successfully');window.location='/myapp/adddiseasepet_get/'</script>")


def viewdisease_get (request):
    data=Disease.objects.all()
    return render(request, "pet shop/diseaseview.html",{"data":data})


def viewdisease_post (request):
    diseasename = request.POST['textfield']
    image = request.POST['filefield']
    Description = request.POST['textarea']
    remedy = request.POST['textfield2']
    return HttpResponse("ok")

def editdisease_get (request,id):
    data=Disease.objects.get(id=id)
    return render(request, "pet shop/dieseaseedit.html",{"data":data})

def editdisease_post (request):
    diseasename= request.POST['textfield']
    Description = request.POST['textarea']
    remedy= request.POST['textfield2']
    id= request.POST['id']
    x = Disease.objects.get(id=id)
    if "fileField" in request.FILES:
        image = request.FILES['fileField']
        date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
        f = FileSystemStorage()
        f.save(date, image)
        path = f.url(date)
        x.image = path
        x.save()
    x.disease_name = diseasename
    x.description = Description
    x.SHOPNAME = Pet_shop.objects.get(LOGIN_id=request.session['lid'])
    x.remedy = remedy
    x.save()
    return HttpResponse("<script>alert('Edited Successfully');window.location='/myapp/Viewdisease/'</script>")

def deletedisease_get(request,id):
    Disease.objects.filter(id=id).delete()
    return HttpResponse("<script>alert('Deleted Successfully');window.location='/myapp/Viewdisease/'</script>")

def deletedisease_post (request):
    return HttpResponse("deleted")



def reviewpet_get(request,id):
    data=Pet_Review.objects.filter(PET_id=id)
    return render(request, "pet shop/Petreview.html",{"data":data})

def reviewpet_post (request):
    return HttpResponse("ok")

def addgrooming_get (request):
    return render(request, "pet shop/managegroomingadd.html")

def addgrooming_post (request):
    groomingname = request.POST['textfield']
    groomingprice= request.POST['textfield2']
    packagedetails= request.POST['textarea']
    date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"


    x = Grooming()
    x.grooming_name = groomingname
    x.grooming_price = groomingprice
    x.package_details= packagedetails
    x.SHOPNAME= Pet_shop.objects.get(LOGIN_id=request.session['lid'])



    x.save()

    return HttpResponse("<script>alert('Added Successfully');window.location='/myapp/Viewgrooming/'</script>")

def viewgrooming_get (request):
    data=Grooming.objects.all()
    return render(request, "pet shop/managegroomingview.html",{"data":data})


def viewgrooming_post (request):
    shopname = request.POST['textfield']
    return HttpResponse("ok")





def editgrooming_get (request,id):
    data=Grooming.objects.get(id=id)
    return render(request, "pet shop/managegroomingedit.html",{"data":data})

def editgrooming_post (request):
    groomingname = request.POST['textfield']
    groomingprice = request.POST['textfield2']
    packagedetails = request.POST['textarea']
    id=request.POST['id']

    x = Grooming.objects.get(id=id)
    x.grooming_name = groomingname
    x.grooming_price = groomingprice
    x.package_details= packagedetails

    x.save()
    return HttpResponse("<script>alert('Edited Successfully');window.location='/myapp/Viewgrooming/'</script>")


def deletegrooming_get (request,id):
    Grooming.objects.filter(id=id).delete()
    return HttpResponse("<script>alert('Deleted Successfully');window.location='/myapp/Viewgrooming/'</script>")

def deletedgrooming_post (request):
    return HttpResponse("ok")



def viewgroomingreq_get (request):
    data=Grooming_Request.objects.filter(status="pending")
    return render(request,"pet shop/mgviewreq.html",{"data":data})

def viewgroomingreq_post (request):
    fromd= request.POST['textfield']
    todate = request.POST['textfield4']
    return HttpResponse("ok")


def approvingroomingreq_get(request,id):
    data=Grooming_Request.objects.filter(id=id).update(status="Approved",paystatus='Approved')
    return HttpResponse("<script>alert('Grooming Request Approved');window.location='/myapp/Viewgroomingreq/'</script>")


def rejectinggroomingreq_get (request,id):
    data=Grooming_Request.objects.filter(id=id).update(status="rejected")
    return HttpResponse("<script>alert(' Grooming Request Rejected');window.location='/myapp/Viewgroomingreq/'</script>")


def viewapprovedgroomingreq_get (request):
    data=Grooming_Request.objects.filter(status="Approved")
    return render(request,"pet shop/viewapprovedgroomingrequest.html",{"data":data})

def viewapprovedgroomingreq_post (request):
    fromd= request.POST['textfield']
    todate = request.POST['textfield4']
    return HttpResponse("ok")



def viewrejectedgroomingreq_get (request):
    data=Grooming_Request.objects.filter(status="Rejected")
    return render(request,"pet shop/viewrejectededgroomingrequest.html",{"data":data})

def viewrejectedgroomingreq_post (request):
    fromd= request.POST['textfield']
    todate = request.POST['textfield4']
    return HttpResponse("ok")
#
# def view_request_get(request):
#     Grooming_Request.objects.filter(GROOMING__SHOPNAME__LOGIN_id=request.session['lid'])
#     return render(request,"pet shop/mgviewreq.html",{"data":data})
#


def viewdeliveryboy_get (request):
    # request.session['orderid']=id
    data=Delivery_boy.objects.all()
    return render(request,"pet shop/mgviewassign.html",{"data":data})

def viewdeliveryboy_post (request):
    slno = request.POST['textfield']
    name= request.POST['textfield2']
    number = request.POST['textfield3']
    email = request.POST['textfield4']
    photo = request.POST['filefield']
    return HttpResponse("ok")


def vieworder_get (request):
    data=Order_Main.objects.filter(SHOPNAME__LOGIN_id=request.session['lid'])
    return render(request,"pet shop/orders.html",{"data":data})

def vieworder_post (request):
    slno = request.POST['textfield']
    date= request.POST['textfield2']
    userdetails= request.POST['textfield3']
    amount = request.POST['textfield4']
    return HttpResponse("ok")
def viewpetorder_get (request):
    data=Pet_Order_Main.objects.filter(SHOPNAME__LOGIN_id=request.session['lid'])
    return render(request, "pet shop/pet orders.html", {"data":data})

def viewpetorder_post (request):
    slno = request.POST['textfield']
    date= request.POST['textfield2']
    userdetails= request.POST['textfield3']
    amount = request.POST['textfield4']
    return HttpResponse("ok")



def moreorderpetdetails_get (request,id):
    data=Pet_Order_Sub.objects.filter(PET_ORDER_MAIN_id=id)
    # total=0
    # for i in data:
    #     print(i.quantity)
    #     amount=Pet_Order_Main.objects.get(id=i.PET_ORDER_MAIN.id).amount
    #     print(amount)
    #     total=int(amount)*int(i.quantity)
    #     print(total)
    return render(request, "pet shop/more_petorder_details.html", {"data":data})
    # return render(request, "pet shop/more_petorder_details.html", {"data":data, "total":int(total)})

def moreorderpetdetails_post (request):
    slno = request.POST['textfield']
    Pet= request.POST['textfield2']
    userdetails= request.POST['textfield3']
    amount = request.POST['textfield4']
    return HttpResponse("ok")

def moreorderdetails_get (request,id):
    total=0
    data=Order_Sub.objects.filter(ORDER_MAIN_id=id)
    for i in data:
        print(i.quantity)
        amount=Order_Main.objects.get(id=i.ORDER_MAIN_id).amount
        print(amount)
        total=int(amount)*int(i.quantity)
        print(total)
    return render(request,"pet shop/more_order_details.html",{"data":data,"total":total})

def moreorderdetails_post (request):
    slno = request.POST['textfield']
    Pet= request.POST['textfield2']
    userdetails= request.POST['textfield3']
    amount = request.POST['textfield4']
    return HttpResponse("ok")



def assignorder_get(request,id):
    res=Delivery_boy.objects.all()

    return render(request,'pet shop/assign deliveryboy.html',{'data':res,'id':id})

def assignorder_get_post(request):
    oid=request.POST['oid']
    deli=request.POST['del']
    data=Pet_assign_Delivery_boy()
    data.date=datetime.now().today()
    data.status="pending"
    data.DELIVERY_BOY_id=deli
    # data.ORDER_MAIN_id=request.session['orderid']
    data.ORDER_MAIN_id=oid
    data.save()
    return HttpResponse("<script>alert('Assinged Successfully');window.location='/myapp/view_assigned_order_get/'</script>")



def view_assigned_order_get(request):
    # data=Assign_Deliery_boy.objects.filter(ORDER_MAIN__SHOPNAME__LOGIN_id=request.session['lid'])
    data=Pet_assign_Delivery_boy.objects.filter(ORDER_MAIN__SHOPNAME__LOGIN_id=request.session['lid'])
    # for i in data:
    #     amount=Order_Main.objects.get(id=i.ORDER_MAIN_id).amount
    #     print(amount)
    #     q=Order_Sub.objects.get(ORDER_MAIN_id=i.ORDER_MAIN_id).quantity
    #     total=int(amount)*int(q)
    #     print(total)
    # return render(request,"pet shop/order_assign_d.html",{"data":data,"total":total})
    return render(request,"pet shop/order_assign_d.html",{"data":data})


# user flutter


def flutter_login_get(request):
    username = request.POST['username']
    password = request.POST['password']
    lg = Login.objects.filter(username=username, password=password)
    if lg.exists():
        lg1 = Login.objects.get(username=username, password=password)
        lid = lg1.id
        if lg1.type == 'deliveryboy':
            return JsonResponse({"status":"ok","lid":str(lid),"type":"deliveryboy"})

        if lg1.type == 'user':
            return JsonResponse({"status":"ok","lid":str(lid),"type":"user"})
        else:
            return JsonResponse({"status":"No"})
    else:
        return JsonResponse({"status": "No" })


def Flutter_Change_password_get(request):
    currentpassword = request.POST['current_password']
    newpassword = request.POST['new_password']
    confirmpassword = request.POST['confirm_password']
    lid = request.POST['lid']

    ch = Login.objects.filter(id=lid, password=currentpassword)
    if ch.exists():
        Login.objects.get(id=lid, password=currentpassword)
        if newpassword == confirmpassword:
            Login.objects.filter(id=lid).update(password=confirmpassword)
            return JsonResponse({"status":"ok"})
        else:
            return JsonResponse({"status":"ok"})
    else:
        return JsonResponse({"status": "ok"})

def user_registeration_get(request):
    name=request.POST['name']
    email=request.POST['email']
    phone_no=request.POST['phone_no']
    place=request.POST['place']
    dob=request.POST['dob']
    gender=request.POST['gender']
    photo=request.POST['photo']
    city=request.POST['city']
    state=request.POST['state']
    pincode=request.POST['pin']
    password=request.POST['password']
    confirmpassword=request.POST['confirm_password']


    if Login.objects.filter(username=email).exists():
        return JsonResponse({"status":'no'})
    if password==confirmpassword:
        z=Login()
        z.username=email
        z.password=password
        z.type='user'
        z.save()

        date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
        f = open(r"C:\Users\HP\Downloads\Telegram Desktop\New folder\petify_dec16 (2)\petify_dec16\media\user" + date, "wb")
        decode = base64.b64decode(photo)
        f.write(decode)
        f.close()
        # path = '/media/user/' + date

        us=User()
        us.username=name
        us.email=email
        us.phone_no=phone_no
        us.place=place
        us.dob=dob
        us.gender=gender
        us.LOGIN=z
        us.city=city
        us.state=state
        us.pincode=pincode
        us.photo='/media/user/'+date
        us.save()
        return JsonResponse({"status":"ok"})
    else:
        return JsonResponse({"status":"no"})



def user_sendrating_post(request):
    review=request.POST['review']
    rating=request.POST['rating']
    lid=request.POST['lid']

    x=Review()
    x.review=review
    x.rating=rating
    x.date=datetime.now().today()
    x.USER=User.objects.get(LOGIN=lid)
    x.save()

    return JsonResponse({"status":"ok"})


def user_viewrating_post(request):
    lid = request.POST['lid']
    x=Review.objects.filter(USER__LOGIN_id=lid)
    a=[]
    for  i in x:
        a.append(
            {
                'id':i.id,
                'review':i.review,
                'rating':i.rating,
                'date':i.date,
                'USER':i.USER.username})

    return JsonResponse({"status": "ok","data":a})




def disease_prediction_get(request):
    disease_name=request.POST['disease_name']
    image=request.POST['image']
    description=request.POST['description']
    remedy=request.POST['remedy']
    lid=request.POST['lid']

    return JsonResponse({"status": "ok"})


def user_view_profile(request):
    lid=request.POST['lid']
    x=User.objects.get(LOGIN_id=lid)
    print(x.photo)
    return JsonResponse({'status':'ok',
                         'name':x.username,
                         'email':x.email,
                         'phoneNo':x.phone_no,
                         'dob':x.dob,
                         'gender':x.gender,
                         'photo1':x.photo,
                         'city':x.city,
                         'place':x.place,
                         'state':x.state,
                         'pin':x.pincode,
                         })



def user_editprofile_get(request):
    name=request.POST['name']
    email=request.POST['email']
    phone_no=request.POST['phone_no']
    place=request.POST['place']
    dob=request.POST['dob']
    gender=request.POST['gender']
    photo=request.POST['photo']
    city=request.POST['city']
    state=request.POST['state']
    pincode=request.POST['pin']
    lid=request.POST['lid']

    print(name)

    us=User.objects.get(LOGIN=lid)

    if len(photo)>1:
        date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
        f = open(r"C:\Users\HP\Downloads\Telegram Desktop\New folder\petify_dec16 (2)\petify_dec16\media\user\\" + date, "wb")
        decode=base64.b64decode(photo)
        f.write(decode)
        f.close()
        us.photo='/media/user/'+date
        us.save()

    # path = '/media/user/' + date

    us.username=name
    us.email=email
    us.phone_no=phone_no
    us.place=place
    us.dob=dob
    us.gender=gender
    us.city=city
    us.state=state
    us.pincode=pincode
    us.save()
    return JsonResponse({"status":"ok"})
#######pet
def addtocart_get(request):
    lid = request.POST['lid']
    Pet=request.POST['pet']
    quantity=request.POST['quantity']
    x=Pet_Cart()
    x.PET_id=Pet
    x.USER=User.objects.get(LOGIN=lid)
    x.Quantity=quantity
    x.save()
    return JsonResponse({"status":"ok"})




#
# def flutter_viewpet_get(request):
#     lid=request.POST['lid']
#     data=Pet.objects.exclude(LOGIN=lid)
#     l=[]
#     for i in data:
#         name=""
#         if i.addtype=='shop':
#             name=Pet_shop.objects.get(LOGIN_id=i.LOGIN.id)
#             l.append({
#                 "id":i.id,
#                 "photo":i.photo,
#                 "breed":i.breed,
#                 "age":i.age,
#                 "description":i.description,
#                 "price":i.price,
#                 "gender":i.gender,
#                 "type":i.type,
#                 "name":name.shopname,
#                 "place":name.place,
#                 "post":name.post,
#                 "phone_no":name.phone_no
#                 })
#
#         elif i.addtype == 'user':
#
#             name = User.objects.get(LOGIN_id=i.LOGIN.id)
#             l.append({
#                 "id": i.id,
#                 "photo": i.photo,
#                 "breed": i.breed,
#                 "age": i.age,
#                 "description": i.description,
#                 "price": i.price,
#                 "gender": i.gender,
#                 "type": i.type,
#                 "name": name.username,
#                 "place": name.place,
#                 # "post": name.post,
#                 "phone_no": name.phone_no,
#
#             })
#     print(l)
#     return JsonResponse({'status':'ok','data':l})


from django.http import JsonResponse
from myapp.models import Pet, Pet_shop, User

def flutter_viewpet_get(request):
    lid = request.POST['lid']
    data = Pet.objects.exclude(LOGIN=lid)
    l = []

    for i in data:
        try:
            if i.addtype == 'shop':
                try:
                    name = Pet_shop.objects.get(LOGIN_id=i.LOGIN.id)
                    l.append({
                        "id": i.id,
                        "loginid": i.LOGIN.id,
                        "photo": i.photo,
                        "breed": i.breed,
                        "age": i.age,
                        "description": i.description,
                        "price": i.price,
                        "gender": i.gender,
                        "type": i.type,
                        "name": name.shopname,
                        "place": name.place,
                        "post": name.post,
                        "phone_no": name.phone_no
                    })
                except Pet_shop.DoesNotExist:
                    continue  # skip this entry if no Pet_shop found

            elif i.addtype == 'user':
                try:
                    name = User.objects.get(LOGIN_id=i.LOGIN.id)
                    l.append({
                        "id": i.id,
                        "photo": i.photo,
                        "breed": i.breed,
                        "age": i.age,
                        "description": i.description,
                        "price": i.price,
                        "gender": i.gender,
                        "type": i.type,
                        "name": name.username,
                        "place": name.place,
                        "phone_no": name.phone_no,
                    })
                except User.DoesNotExist:
                    continue  # skip this entry if no User found

        except Exception as e:
            print(f"Error processing pet id {i.id}: {e}")
            continue

    return JsonResponse({'status': 'ok', 'data': l})



def view_cart_get(request):
    lid = request.POST['lid']
    x=Pet_Cart.objects.filter(USER__LOGIN_id=lid)
    l=[]
    for i in x:
        l.append({
            "id":i.id,
            "photo":i.PET.photo,
            "breed":i.PET.breed,
            "description":i.PET.description,
            "price": i.PET.price,
            "quantity": i.Quantity,
            })
    return JsonResponse({"status":"ok",'data':l})

def remove_item_get(request):
    cid = request.POST['cid']
    Pet_Cart.objects.get(id=cid).delete()
    return JsonResponse({"status":"ok"})



#########products

def flutter_viewpetproducts_get(request):
    data=Pet_products.objects.all()
    l=[]
    for i in data:
        l.append({
            "id":i.id,
            "photo":i.photo,
            "product_name":i.product_name,
            "description":i.description,
            "price":i.price,
            "type":i.type,
            "shop_name":i.SHOPNAME.shopname,
            "shopPlace":i.SHOPNAME.place,
            "shopPost":i.SHOPNAME.post,
            "shopPhone":i.SHOPNAME.phone_no,
        })
    print(l)
    return JsonResponse({'status':'ok','data':l})


def addtocart_products_get(request):
    lid = request.POST['lid']
    product=request.POST['pid']
    quantity=request.POST['quantity']
    x=Products_Cart()
    x.PET_PRODUCTS_id=product
    x.USER=User.objects.get(LOGIN=lid)
    x.Quantity=quantity
    x.save()
    return JsonResponse({"status":"ok"})



def view_cart_products_get(request):
    lid = request.POST['lid']
    x=Products_Cart.objects.filter(USER__LOGIN_id=lid)
    l=[]
    for i in x:
        l.append({
            "id":i.id,
            "product":i.PET_PRODUCTS.product_name,
            "photo":i.PET_PRODUCTS.photo,
            "description":i.PET_PRODUCTS.description,
            "price": i.PET_PRODUCTS.price,
            "quantity": i.Quantity,
            })
    return JsonResponse({"status":"ok",'data':l})

def remove_item_product_get(request):
    cid = request.POST['cid']
    Products_Cart.objects.get(id=cid).delete()
    return JsonResponse({"status":"ok"})


def flutter_viewsellpet_get(request):
    data=Pet.objects.filter(type="SELL")
    l=[]
    for i in data:
        l.append({
            "id":i.id,
            "photo":i.photo,
            "breed":i.breed,
            "age":i.age,
            "description":i.description,
            "price":i.price,
            "gender":i.gender,
            "type":i.type,
            "shop_name":i.SHOPNAME.shopname,
            "shop_place":i.SHOPNAME.place,
            "shop_post":i.SHOPNAME.post,
            "shop_phone_no":i.SHOPNAME.phone_no,
        })
    print(l)
    return JsonResponse({'status':'ok','data':l})


def user_sell_pet (request):
    photo=request.POST['photo']
    breed=request.POST['breed']
    age = request.POST['age']
    Description = request.POST['description']
    price = request.POST['price']
    gender = request.POST['gender']
    type = request.POST['type']
    lid = request.POST['lid']

    date = datetime.now().strftime('%Y%m%d-%H%M%S') + ".jpg"
    f = open(r"C:\Users\HP\Downloads\Telegram Desktop\New folder\petify_dec16 (2)\petify_dec16\media\sellpet\\" + date, "wb")
    decode = base64.b64decode(photo)
    f.write(decode)
    f.close()



    x = Pet()
    x.photo = '/media/sellpet/' + date
    x.breed = breed
    x.age = age
    x.description = Description
    x.price = price
    x.LOGIN=Login.objects.get(id=lid)
    x.gender = gender
    x.type=type
    x.addtype='user'
    x.save()

    return JsonResponse({'status':'ok'})




def flutter_viewmypets_get(request):
    lid=request.POST['lid']
    data=Pet.objects.filter(LOGIN_id=lid)
    l=[]
    for i in data:
        l.append({
            "id":i.id,
            "photo":i.photo,
            "breed":i.breed,
            "age":i.age,
            "description":i.description,
            "price":i.price,
            "gender":i.gender,
            "type":i.type,
        })
    return JsonResponse({'status':'ok','data':l})


def flutter_userviewgrooming_get(request):
    data=Grooming.objects.all()
    l=[]
    for i in data:
        l.append({
            "id":i.id,
            "grooming_name":i.grooming_name,
            "grooming_price":i.grooming_price,
            "package_details":i.package_details,
            "shop_name":i.SHOPNAME.shopname,


        })
    print(l)
    return JsonResponse({'status':'ok','data':l})

def flutter_usersendreq_get(request):
    lid=request.POST['lid']
    gid=request.POST['gid']
    g=Grooming_Request()
    g.USER=User.objects.get(LOGIN_id=lid)
    g.date=datetime.now().date()
    g.status='pending'
    g.paystatus='pending'
    g.GROOMING=Grooming.objects.get(id=gid)
    g.save()

    return JsonResponse({'status':'ok'})

def flutter_userviewreq_get(request):
    lid=request.POST['lid']
    data=Grooming_Request.objects.filter(USER__LOGIN_id=lid)
    l=[]
    for i in data:
        l.append({
            "id":i.id,
            "grooming_name":i.GROOMING.grooming_name,
            "grooming_price":i.GROOMING.grooming_price,
            "package_details":i.GROOMING.package_details,
            "status":i.status,
            "paystatus":i.paystatus,
            "date":i.date,
            "t":"",
            "shop_name":i.GROOMING.SHOPNAME.shopname,

        })
    print(l)
    return JsonResponse({'status':'ok','data':l})
def flutter_userviewgroomget(request):
    lid=request.POST['lid']
    data=Grooming.objects.all()
    l=[]
    for i in data:
        t='no'
        if Grooming_Request.objects.filter(USER__LOGIN_id=lid,GROOMING=i.id).exists():
            t="yes"
        l.append({
            "id":i.id,
            "grooming_name":i.grooming_name,
            "grooming_price":i.grooming_price,
            "package_details":i.package_details,
            "status":"",
            "paystatus":"",
            "date":"",
            "t":t,
            "shop_name":i.SHOPNAME.shopname,

        })
    print(l)
    return JsonResponse({'status':'ok','data':l})




###################



def cartpayment(request):
    lid= request.POST["lid"]

    c=Products_Cart.objects.filter(USER__LOGIN_id=lid)

    cids=[]

    for i in c:
        if i.PET_PRODUCTS.SHOPNAME.id not in cids:
            cids.append(i.PET_PRODUCTS.SHOPNAME.id)
    from datetime import  datetime
    for i in cids:
        c = Products_Cart.objects.filter(USER__LOGIN_id=lid,PET_PRODUCTS__SHOPNAME_id=i)

        b=Order_Main()
        b.USER= User.objects.get(LOGIN_id=lid)
        b.date= datetime.now()
        b.amount="0"
        b.SHOPNAME_id=i
        b.save()


        amts=0
        for i in c:
            bb=Order_Sub()
            bb.quantity= i.Quantity
            bb.PET_PRODUCTS=i.PET_PRODUCTS
            bb.ORDER_MAIN= b
            bb.save()

            amts = amts + ( float(i.Quantity) * float(i.PET_PRODUCTS.price) )

        b.amount= str(amts)
        b.save()
        p=Payment()
        p.ORDER_MAIN=b
        p.status='paid'
        p.amount= str(amts)
        p.USER=User.objects.get(LOGIN=lid)
        p.date=datetime.now().today()
        p.save()




    return  JsonResponse(
        {
            'status':'ok'
        }
    )

def user_view_product_cart(request):
    lid= request.POST["lid"]
    c=Products_Cart.objects.filter(USER__LOGIN_id=lid)
    l=[]
    amnt=0
    for i in c:
        amnt += int(i.Quantity) * int(i.PET_PRODUCTS.price)
        print(amnt,'dddd')
        l.append(
            {
                'quantity':i.Quantity,
                "description": i.PET_PRODUCTS.description,
                'price':i.PET_PRODUCTS.price,
                'photo':i.PET_PRODUCTS.photo,
                'id':i.id,
                "product": i.PET_PRODUCTS.product_name,

            }
        )
    return JsonResponse(
        {
            'status':'ok',
            'data':l,
            'amount':amnt
        }
    )
############################3



# def cartpayment_pet(request):
#     lid= request.POST["lid"]
#
#     c=Pet_Cart.objects.filter(USER__LOGIN_id=lid)
#
#     cids=[]
#
#     for i in c:
#         if i.PET.SHOPNAME.id not in cids:
#             cids.append(i.PET.SHOPNAME.id)
#     from datetime import  datetime
#     for i in cids:
#         c = Pet_Cart.objects.filter(USER__LOGIN_id=lid,PET__SHOPNAME_id=i)
#
#         b=Pet_Order_Main()
#         b.USER= User.objects.get(LOGIN_id=lid)
#         b.date= datetime.now()
#         b.amount="0"
#         b.SHOPNAME_id=i
#         b.save()
#
#
#         amts=0
#         for i in c:
#             bb=Pet_Order_Sub()
#             bb.quantity= i.Quantity
#             bb.PET=i.PET
#             bb.PET_ORDER_MAIN= b
#             bb.save()
#
#             amts = amts + ( float(i.Quantity) * float(i.PET.price) )
#
#         b.amount= str(amts)
#         b.save()
#         p=Pet_Payment()
#         p.PET_ORDER_MAIN=b
#         p.status='paid'
#         p.amount= str(amts)
#         p.USER=User.objects.get(LOGIN=lid)
#         p.date=datetime.now().today()
#         p.save()
#
#
#
#
#     return  JsonResponse(
#         {
#             'status':'ok'
#         }
#     )
def cartpayment_pet(request):
    lid= request.POST["lid"]

    c=Pet_Cart.objects.filter(USER__LOGIN_id=lid)

    cids=[]

    for i in c:
        ss=Pet_shop.objects.get(LOGIN_id=i.PET.LOGIN.id)
        SHOPNAME=ss.id
        if SHOPNAME  not in cids:
            cids.append(SHOPNAME)
    from datetime import  datetime
    for i in cids:
        c = Pet_Cart.objects.filter(USER__LOGIN_id=lid)

        b=Pet_Order_Main()
        b.USER= User.objects.get(LOGIN_id=lid)
        b.date= datetime.now()
        b.amount="0"
        b.SHOPNAME_id=SHOPNAME
        b.status='paid'
        b.save()


        amts=0
        for i in c:
            bb=Pet_Order_Sub()
            bb.quantity= i.Quantity
            bb.PET=i.PET
            bb.PET_ORDER_MAIN= b
            bb.save()

            amts = amts + ( float(i.Quantity) * float(i.PET.price) )

        b.amount= str(amts)
        b.save()
        p=Pet_Payment()
        p.PET_ORDER_MAIN=b
        p.status='paid'
        p.amount= str(amts)
        p.USER=User.objects.get(LOGIN=lid)
        p.date=datetime.now().today()
        p.save()




    return  JsonResponse(
        {
            'status':'ok'
        }
    )

def user_view_pets_cart(request):
    lid= request.POST["lid"]
    c=Pet_Cart.objects.filter(USER__LOGIN_id=lid)
    l=[]
    amnt=0
    for i in c:
        amnt += int(i.Quantity) * int(i.PET.price)
        print(amnt,'dddd')
        l.append(
            {
                "id": i.id,
                "photo": i.PET.photo,
                "breed": i.PET.breed,
                "description": i.PET.description,
                "price": i.PET.price,
                "quantity": i.Quantity,

            }
        )
    return JsonResponse(
        {
            'status':'ok',
            'data':l,
            'amount':amnt
        }
    )



def Grooming_payment(request):
    mid=request.POST['mid']
    lid=request.POST['lid']
    amount=request.POST['amount']
    x=groom_Payment()
    x.status='paid'
    x.amount=amount
    x.USER=User.objects.get(LOGIN_id=lid)
    x.GROOMING_REQUEST_id=mid
    x.date=datetime.now().today()
    x.save()
    Grooming_Request.objects.filter(id=mid).update(paystatus='paid',status="paid")
    return JsonResponse(
        {
            'status': 'ok'
        }
    )

def view_payments(request):
    lid= request.POST["lid"]
    print(lid)
    p=Pet_Payment.objects.filter(USER__LOGIN_id=lid)
    g=groom_Payment.objects.filter(USER__LOGIN_id=lid)
    r=Payment.objects.filter(USER__LOGIN_id=lid)
    l=[]
    for i in r:
        l.append(
            {
                "id": i.id,
                "date": i.date,
                "status": i.status,
                "Order_Details": Order_Sub.objects.get(ORDER_MAIN_id=i.ORDER_MAIN_id).PET_PRODUCTS.product_name,
                # "Payment_Details": Order_Sub.objects.get(ORDER_MAIN_id=i.ORDER_MAIN_id).PET_PRODUCTS.price,
                "Payment_Details": i.amount,
                "ptype":"Product",
                # "quantity": i.quantity,

            }
        )
    for i in p:
        l.append(
            {
                "id": i.id,
                "date": i.date,
                "status": i.status,
                "Payment_Details": i.amount,
                "Order_Details": Pet_Order_Sub.objects.get(PET_ORDER_MAIN_id=i.PET_ORDER_MAIN_id).PET.breed,
                "ptype": "Pet",

            }
        )
    for i in g:
        l.append(
            {
                "id": i.id,
                "date": i.date,
                "status": i.status,
                "Order_Details":i.GROOMING_REQUEST.GROOMING.grooming_name,
                "Payment_Details": i.amount,
                "ptype": "Grooming",

            }
        )
    print(l)
    return JsonResponse(
        {
            'status':'ok',
            'data':l,

        }
    )

def viewproduct_payments(request):
    lid= request.POST["lid"]
    c=Payment.objects.filter(USER__LOGIN_id=lid)
    l=[]
    for i in c:
        l.append(
            {
                "id": i.id,
                "date": i.date,
                "status": i.status,
                "name": i.name,
                "amount": i.amount,
                "quantity": i.quantity,

            }
        )
    return JsonResponse(
        {
            'status':'ok',
            'data':l,

        }
    )


def viewgrooming_payments(request):
    lid = request.POST["lid"]
    c = Payment.objects.filter(USER__LOGIN_id=lid)
    l = []
    for i in c:
        l.append(
            {
                "id": i.id,
                "date": i.date,
                "status": i.status,
                "name": i.name,
                "amount": i.amount,
                "quantity": i.quantity,

            }
        )
    return JsonResponse(
        {
            'status': 'ok',
            'data': l,

        }
    )




def del_viewreviewrating(request):
    res=Review.objects.all()
    l = []
    for i in res:

        l.append({
            'id':i.id,
            'review':i.review,
            'rating':i.rating,
            'date':i.date,
            'userid':i.USER.username,

        })

    return JsonResponse(
        {
            'status': 'ok',
            'data': l,

        }
    )



def del_viewassignedworg(request):
    lid=request.POST['lid']
    res=Pet_assign_Delivery_boy.objects.filter(DELIVERY_BOY__LOGIN_id=lid)
    l = []
    for i in res:

        l.append({
            'id':i.id,
            'statuss':i.status,
            'amount':i.ORDER_MAIN.amount,
            'date':i.date,
            'username':i.ORDER_MAIN.USER.username,
            'phone':i.ORDER_MAIN.USER.phone_no,
            'place':i.ORDER_MAIN.USER.place,
            'city':i.ORDER_MAIN.USER.city,
            'pincode':i.ORDER_MAIN.USER.pincode,
            'email':i.ORDER_MAIN.USER.email,

        })

    return JsonResponse(
        {
            'status': 'ok',
            'data': l,

        }
    )


def del_update_order(request):
    lid=request.POST['lid']
    oid=request.POST['oid']
    a=Pet_assign_Delivery_boy.objects.get(id=oid)
    a.date=datetime.now().today()
    a.status='delivered'
    a.ORDER_MAIN_id=oid
    a.DELIVERY_BOY=Delivery_boy.objects.get(LOGIN=lid)
    a.save()
    return JsonResponse(
        {
            'status': 'ok',


        }
    )


def del_view_profile(request):
    lid=request.POST['lid']
    x=Delivery_boy.objects.get(LOGIN_id=lid)
    print(x.photo)
    return JsonResponse({'status':'ok',
                         'name':x.name,
                         'phone_no':x.phone_no,
                         'bike_no':x.bike_no,
                         'bike_details':x.bike_details,
                         'photo':x.photo,
                         'email':x.email,

                         })

















#############################





def view_nearby_vets(request):
    c = Vets.objects.all()
    l = []
    for i in c:
        l.append(
            {
                "id": i.id,
                "Clinic": i.Clinic,
                "Photo":i.photo,
                "Location": i.Location,
                "Phone_Number": i.Phone_Number,
                "Email": i.Email,
                "Latitude": i.Latitude,
                "Longitude": i.Longitude,

            }
        )

    print(l)
    return JsonResponse(
        {
            'status': 'ok',
            'data': l,

        }
    )

def add_nearby_vets_get (request):
    return render(request, "admin/add veterinary.html")


def add_nearby_vets_post(request):
    clinic_name=request.POST['textfield']
    Location=request.POST['textfield2']
    Phone_no=request.POST['textfield3']
    Latitude=request.POST['textfield4']
    Longitude=request.POST['textfield5']
    Email=request.POST['textfield6']
    Photo=request.FILES['fileField']
    fs=FileSystemStorage()
    date=datetime.now().strftime('%Y%m%d-%H%M%S')+'.jpg'
    fs.save(date,Photo)
    path=fs.url(date)
    a=Vets()
    a.Clinic=clinic_name
    a.Location=Location
    a.Latitude=Latitude
    a.Longitude=Longitude
    a.Phone_Number=Phone_no
    a.Email=Email
    a.photo=path
    a.save()
    return HttpResponse("<script>alert('Added Successfully');window.location='/myapp/adminhome/'</script>")




from django.http import JsonResponse
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder

def pet_disease_prediction(request):
    try:
        # Get the input data from the request
        a = request.POST['a']
        print(f"Input data: {a}")

        # Split the input string into a list of integers
        c = a.split(",")
        m = [int(i) for i in c if i.strip()]  # Convert to integers and ignore empty strings
        print(f"Processed input: {m}")
        print(len(m))

        # Load the dataset
        data = pd.read_csv(r"C:\Users\HP\Downloads\PETPIOLETWEB\PETPIOLETWEB\dataset\pet_disease_dataset.csv")

        # Check for missing values
        data.fillna(0, inplace=True)

        # Encode the target variable
        label_encoder = LabelEncoder()
        data['prognosis'] = label_encoder.fit_transform(data['prognosis'])

        # Split features and target
        X = data.drop(columns=['pet_id', 'prognosis'])
        y = data['prognosis']

        # Train a RandomForestClassifier
        model = RandomForestClassifier(n_estimators=100, random_state=42)
        model.fit(X, y)

        # Make predictions
        result = model.predict([m[:131]])
        predicted_disease = label_encoder.inverse_transform(result)[0]
        print(f"Predicted Disease: {predicted_disease}")

        # Return the result as a JSON response
        return JsonResponse({'status': 'ok', 'l': predicted_disease})

    except Exception as e:
        print(f"Error: {e}")
        return JsonResponse({'status': 'error', 'message': str(e)})








def chat1(request,id):
    request.session["userid"] = id
    cid = str(request.session["userid"])
    request.session["new"] = cid
    qry = User.objects.get(LOGIN=cid)

    return render(request, "pet shop/Chat.html", {'photo': qry.photo, 'name': qry.username, 'toid': cid})

def chat_view(request):
    fromid = request.session["lid"]
    toid = request.session["userid"]
    qry = User.objects.get(LOGIN=request.session["userid"])
    from django.db.models import Q

    res = Chat.objects.filter(Q(FROMID_id=fromid, TOID_id=toid) | Q(FROMID_id=toid, TOID_id=fromid))
    l = []

    for i in res:
        l.append({"id": i.id, "message": i.message, "to": i.TOID_id, "date": i.date, "from": i.FROMID_id})

    return JsonResponse({'photo': qry.photo, "data": l, 'name': qry.username, 'toid': request.session["userid"]})

def chat_send(request, msg):
    lid = request.session["lid"]
    toid = request.session["userid"]
    message = msg

    import datetime
    d = datetime.datetime.now().date()
    chatobt = Chat()
    chatobt.message = message
    chatobt.TOID_id = toid
    chatobt.FROMID_id = lid
    chatobt.date = d
    chatobt.time=datetime.datetime.now().time()
    chatobt.save()

    return JsonResponse({"status": "ok"})




def User_sendchat(request):
    FROM_id=request.POST['from_id']
    TOID_id=request.POST['to_id']
    print(FROM_id)
    print(TOID_id)
    msg=request.POST['message']

    from  datetime import datetime
    c=Chat()
    c.FROMID_id=FROM_id
    c.TOID_id=TOID_id
    c.message=msg
    c.time=datetime.now().time()
    c.date=datetime.now()
    c.save()
    return JsonResponse({'status':"ok"})


def User_viewchat(request):
    fromid = request.POST["from_id"]
    toid = request.POST["to_id"]
    # lmid = request.POST["lastmsgid"]
    from django.db.models import Q

    res = Chat.objects.filter(Q(FROMID_id=fromid, TOID_id=toid) | Q(FROMID_id=toid, TOID_id=fromid))
    l = []

    for i in res:
        l.append({"id": i.id, "msg": i.message, "from": i.FROMID_id, "date": i.date, "to": i.TOID_id})

    return JsonResponse({"status":"ok",'data':l})



def forget_password_post(request):
    em = request.POST['email']
    import random
    password = random.randint(00000000, 99999999)
    log = Login.objects.filter(username=em)
    if log.exists():
        logg = Login.objects.get(username=em)
        message = 'temporary password is ' + str(password)
        send_mail(
            'temp password',
            message,
            settings.EMAIL_HOST_USER,
            [em, ],
            fail_silently=False
        )
        logg.password = password
        logg.save()
        return JsonResponse({'status':'ok'})
    else:
        return JsonResponse({'status':'no'})

def view_assigned_order(request):
    lid=request.POST['lid']
    c = Pet_assign_Delivery_boy.objects.filter(ORDER_MAIN__USER__LOGIN_id=lid)
    l = []
    for i in c:

        ordersubb=Pet_Order_Sub.objects.get(PET_ORDER_MAIN_id=i.ORDER_MAIN.id)
        l.append(
            {
                "id": i.id,
                "date": i.date,
                "status": i.status,
                "petname": ordersubb.PET,
                "Phone_Number": i.Phone_Number,
                "Email": i.Email,
                "Latitude": i.Latitude,
                "Longitude": i.Longitude,

            }
        )

    print(l)
    return JsonResponse(
            {
                'status': 'ok',
                'data': l,

            }
        )


from django.views.decorators.csrf import csrf_exempt
import json
import google.generativeai as genai

# Replace with your actual API key
GOOGLE_API_KEY = 'AIzaSyAaKvYDYAMj_jbpbvuiTOKhpBdQM10DaMI'
genai.configure(api_key=GOOGLE_API_KEY)

model = None
for m in genai.list_models():
    if 'generateContent' in m.supported_generation_methods:
        print(m.name)
        model = genai.GenerativeModel('gemini-1.5-flash')
        break

def generate_gemini_response(prompt):
    # Directly use the user's question as the prompt
    response = model.generate_content(prompt)
    return response.text


@csrf_exempt
def chat(request):
    if request.method == 'POST':
        user_message = json.loads(request.body).get('message')
        # Generate a response based on the user message without additional context
        gemini_response = generate_gemini_response(user_message)
        return JsonResponse({'response': gemini_response})





#########################

def user_view_orders(request):
    lid=request.POST['lid']
    res=Pet_assign_Delivery_boy.objects.filter(ORDER_MAIN__USER__LOGIN_id=lid)
    l=[]
    for i in res:
        ob=Pet_Order_Sub.objects.get(PET_ORDER_MAIN=i.ORDER_MAIN.id)
        l.append({
            'id':i.id,
            'date':i.date,
            'deliveryboyname':i.DELIVERY_BOY.name,
            'deliveryboyphone':i.DELIVERY_BOY.phone_no,
            'amount':i.ORDER_MAIN.amount,
            'petname':ob.PET.breed,
            'quantity':ob.quantity,
            'petprice':ob.PET.price,
            'shopname':i.ORDER_MAIN.SHOPNAME.shopname,
            'loginid':i.ORDER_MAIN.SHOPNAME.LOGIN.id,
        })

    return JsonResponse({'status':'ok','data':l})




def deletepet_flutt(request):
    pid=request.POST['pid']
    Pet.objects.filter(id=pid).delete()
    return JsonResponse(
        {
            'status': 'ok',


        }
    )











