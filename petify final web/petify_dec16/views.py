from django.core.files.storage import FileSystemStorage
from django.core.mail import send_mail
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render

# Create your views here.
from D_HOMES import settings
from myapp.models import *


def login(request):
    return render(request,'loginindex.html')

def login_post(request):
    user=request.POST['username']
    password=request.POST['password']
    log=Login.objects.filter(username=user,password=password)
    if log.exists():
        log1=Login.objects.get(username=user,password=password)
        request.session['lid']=log1.id
        if log1.type=='admin':
            return HttpResponse('''<script>alert("Login Successful");window.location='/myapp/admin_home/'</script>''')
        elif log1.type=='company':
            return HttpResponse('''<script>alert("Login Successful");window.location='/myapp/company_home/'</script>''')

        else:
            return HttpResponse('''<script>alert("Login Invalid");window.location='/myapp/login/'</script>''')
    else:
        return HttpResponse('''<script>alert("Login Invalid");window.location='/myapp/login/'</script>''')


def admin_home(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        return render(request,'ADMIN/adminindex.html')

def change_password(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        return render(request,'ADMIN/change password.html')
def change_password_post(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        oldpassword=request.POST['oldpassword']
        newpassword=request.POST['newpassword']
        confirmpassword=request.POST['confirmpassword']
        log=Login.objects.filter(password=oldpassword)
        if log.exists():
            log1 = Login.objects.get(password=oldpassword, id=request.session['lid'])
            if newpassword==confirmpassword:
                log1 = Login.objects.filter(password=oldpassword, id=request.session['lid']).update(password=confirmpassword)
                return HttpResponse('''<script>alert("changed successfully");window.location='/myapp/login/'</script>''')
            else :
                return HttpResponse('''<script>alert("Failed to change password");window.location='/myapp/change_password/'</script>''')
        else :
            return HttpResponse('''<script>alert("Failed to change password");window.location='/myapp/change_password/'</script>''')



def company_appr_and_rej(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        a=Companies.objects.filter(status="pending")
        return render(request,'ADMIN/company appr and rej.html',{'data':a})


def comp_approve(request, id):
    r = Companies.objects.filter(LOGIN=id).update(status="approved")
    r2 = Login.objects.filter(pk=id).update(type="company")
    return HttpResponse(
        '''<script>alert("SUCCESSFULLY APPROVED");window.location='/myapp/company_appr_and_rej/'</script>''')

def comp_reject(request, id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        r = Companies.objects.filter(LOGIN=id).update(status="comp_reject")
        r2 = Login.objects.filter(pk=id).update(type="company")
        return HttpResponse(
            '''<script>alert("SUCCESSFULLY REJECTED");window.location='/myapp/company_appr_and_rej/'</script>''')

def company_appr_and_rej_post(request):
    search_company=request.POST['company']
    a = Companies.objects.filter(status="pending", name__icontains=search_company)
    return render(request, 'ADMIN/company appr and rej.html', {'data': a})

def view_complaint_and_send_reply(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        c=Complaints.objects.all()
        return render(request,'ADMIN/view complaint and send reply.html',{'data':c})

def view_complaint_and_send_reply_post(request):
    From = request.POST['from']
    to = request.POST['to']
    c = Complaints.objects.filter(date__range=[From,to])
    return render(request, 'ADMIN/view complaint and send reply.html', {'data': c})


def reply(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        return render(request,'ADMIN/reply.html',{'id':id})
def reply_post(request):
    id=request.POST['id']
    reply=request.POST['reply']
    c=Complaints.objects.get(pk=id)
    c.replay=reply
    c.status='REPLIED'
    c.save()
    return HttpResponse('''<script>alert("Reply Submitted");window.location='/myapp/view_complaint_and_send_reply/'</script>''')


def approve_or_reject_freelance(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        f=Freelancer.objects.filter(status="pending")
        return render(request,'ADMIN/approve or reject freelance.html',{'data':f})

def approve(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        r=Freelancer.objects.filter(LOGIN=id).update(status="approved")
        r2=Login.objects.filter(pk=id).update(type="freelance")
        return HttpResponse('''<script>alert("SUCCESSFULLY APPROVED");window.location='/myapp/approve_or_reject_freelance/'</script>''')

def reject(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        y=Freelancer.objects.filter(LOGIN=id).update(status="reject")
        y2=Login.objects.filter(pk=id).update(type="freelance")
        return HttpResponse('''<script>alert("SUCCESSFULLY REJECTED");window.location='/myapp/approve_or_reject_freelance/'</script>''')


def approve_or_reject_freelance_post(request):
    apprejfree=request.POST['apprejfree']
    f=Freelancer.objects.filter(status="pending",name__icontains=apprejfree)
    return render(request,'ADMIN/approve or reject freelance.html',{'data':f})


def view_approved_freelancers(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        f=Freelancer.objects.filter(status="approved")
        return render(request,'ADMIN/view approved freelancers.html',{'data':f})

def view_approved_freelancers_post(request):
    appfreelancers=request.POST['apprejfree']
    f=Freelancer.objects.filter(status="approved",name__icontains=appfreelancers)
    return render(request,'ADMIN/view approved freelancers.html',{'data':f})

def view_rejected_freelancers(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        f=Freelancer.objects.filter(status="reject")
        return render(request,'ADMIN/view rejected freelancers.html',{'data':f})

def view_rejected_freelancers_post(request):
    rejfreelance=request.POST['apprejfree']
    f = Freelancer.objects.filter(status="reject",name__icontains=rejfreelance)
    return render(request, 'ADMIN/view rejected freelancers.html', {'data': f})

def view_approved_comp(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        a=Companies.objects.filter(status="comp_approve")
        return render(request,'ADMIN/view approved comp.html',{'data':a})
def view_approved_comp_post(request):
    viewappcomp=request.POST['company']
    a = Companies.objects.filter(status="comp_approve",name__icontains=viewappcomp)
    return render(request, 'ADMIN/view approved comp.html', {'data': a})


def view_rejected_company(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        a=Companies.objects.filter(status="comp_reject")
        return render(request,'ADMIN/view rejected company.html',{'data':a})

def view_rejected_company_post(request):
    viewrejcomp=request.POST['company']
    a = Companies.objects.filter(status="comp_reject",name__icontains=viewrejcomp)
    return render(request,'ADMIN/view rejected company.html',{'data':a})

def view_review_on_plan(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        vr=Reviews.objects.all()
        return render(request,'ADMIN/view review on plan.html',{'data':vr})

def view_review_on_plan_post(request):
    reviewfrom=request.POST['from']
    reviewto=request.POST['to']
    vr=Reviews.objects.filter(date__range=[reviewfrom,reviewto])
    return render(request,'ADMIN/view review on plan.html',{'data':vr})

def VIEW_APP_FEEDBACK(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        v=Feedback.objects.all()
    return render(request,'ADMIN/VIEW APP FEEDBACK.html',{'data':v})
def VIEW_APP_FEEDBACK_post(request):
    feedbackfrom=request.POST['from']
    feedbackto=request.POST['to']
    v = Feedback.objects.filter(date__range=[feedbackfrom,feedbackto])
    return render(request, 'ADMIN/VIEW APP FEEDBACK.html', {'data': v})

def CATEGORY_MANAGE_ADD(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        return render(request,'ADMIN/CATEGORY MANAGE ADD.html')
def CATEGORY_MANAGE_ADD_post(request):
    catadd=request.POST['catadd']
    ad=Category()
    ad.category_name=catadd
    ad.save()
    return HttpResponse('''<script>alert("Category Added Successfully");window.location='/myapp/CATEGORY_MANAGE_ADD/'</script>''')

def MANAGE_CATEGORY_VIEW(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        cat=Category.objects.all()
        return render(request,'ADMIN/MANAGE CATEGORY VIEW.html',{'data':cat})

def MANAGE_CATEGORY_VIEW_post(request):
    managecatview=request.POST['managecatview']
    cat = Category.objects.filter(category_name__icontains=managecatview)
    return render(request, 'ADMIN/MANAGE CATEGORY VIEW.html', {'data': cat})

def delete_category(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        d=Category.objects.get(id=id)
        d.delete()
        return HttpResponse('''<script>alert("Deleted Successfully");window.location='/myapp/MANAGE_CATEGORY_VIEW/'</script>''')



def MANAGE_CATEGORY_EDIT(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        data=Category.objects.get(id=id)
        return render(request,'ADMIN/MANAGE CATEGORY EDIT.html',{'dt':data})

def MANAGE_CATEGORY_EDIT_post(request):
    id=request.POST['id']
    catedit=request.POST['catedit']

    ed=Category.objects.get(id=id)
    ed.category_name=catedit
    ed.save()
    return HttpResponse('''<script>alert("Category Edited Successfully");window.location='/myapp/MANAGE_CATEGORY_VIEW/'</script>''')







#####################comp


def COMPANY_REGISTER(request):
   return render(request,'company/signup index.html')
def COMPANY_REGISTER_post(request):
    name=request.POST['name']
    building_number=request.POST['bulidingno']
    place=request.POST['place']
    post=request.POST['post']
    since=request.POST['since']
    pin=request.POST['pin']
    district=request.POST['district']
    state=request.POST['state']
    numberofemployee=request.POST['noofemployee']
    phone =request.POST['phone']
    mobile =request.POST['mobile']
    password=request.POST['password']
    conformpassword=request.POST['confirmpassword']
    email = request.POST['email']
    website = request.POST['website']
    status = request.POST['status']

    if password==conformpassword:


        image1=request.FILES['image1']
        from datetime import datetime
        date1="p1"+datetime.now().strftime("%Y%m%d-%H%M%S")+'.jpg'
        fs=FileSystemStorage()
        fn=fs.save(date1,image1)
        path1=fs.url(date1)

        image2 = request.FILES['image2']
        from datetime import datetime
        date2 = "p2"+datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
        fs1 = FileSystemStorage()
        fn1 = fs1.save(date2, image2)
        path2 = fs1.url(date2)

        image3 = request.FILES['image3']
        from datetime import datetime
        date3 = "p3"+datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
        fs2= FileSystemStorage()
        fn2 = fs2.save(date3, image3)
        path3 = fs2.url(date3)

        logo = request.FILES['logo']
        from datetime import datetime
        date4 = "l1"+datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
        fs3 = FileSystemStorage()
        fn3 = fs3.save(date4, logo)
        path4 = fs3.url(date4)

        cer = request.FILES['cer']
        from datetime import datetime
        date5 = "c1"+datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
        fs4 = FileSystemStorage()
        fn4 = fs4.save(date5, cer)
        path5= fs4.url(date5)

        obj=Login()
        obj.username=email
        obj.password=conformpassword
        obj.type='pending'
        obj.save()

        ob=Companies()
        ob.name=name
        ob.building_number =building_number
        ob.place =place
        ob.post =post
        ob.since =since
        ob.pin =pin
        ob.district =district
        ob.state =state
        ob.numberofemployee =numberofemployee
        ob.logo = path4
        ob.image1 =path1
        ob.image2 =path2
        ob.image3 =path3
        ob.phone = phone
        ob.mobile =mobile
        ob.email =email
        ob.website =website
        ob.certificate =path5
        ob.status = status
        ob.LOGIN=obj
        ob.save()
        return HttpResponse('''<script>alert("Registered Successfully");window.location='/myapp/login/'</script>''')
    else:
        return HttpResponse('''<script>alert("Password Missmatch");window.location='/myapp/COMPANY_REGISTER/'</script>''')

# def COMPANY_LOGIN(request):
#     return render(request,'company/COMPANY LOGIN.html')
# def COMPANY_LOGIN_post(request):
#     return HttpResponse('ok')

def VIEW_PROFILE(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Companies.objects.get(LOGIN=request.session['lid'])
        return render(request,'company/VIEW PROFILE.html',{'data':var})
def VIEW_PROFILE_post(request):
    return HttpResponse('ok')

def EDIT_PROFILE(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Companies.objects.get(id=id)
        return render(request,'company/EDIT PROFILE.html',{'data':var})
def EDIT_PROFILE_post(request):
    id=request.POST['id']
    name = request.POST['name']
    building_number = request.POST['bulidingno']
    place = request.POST['place']
    post = request.POST['post']
    since = request.POST['since']
    pin = request.POST['pin']
    district = request.POST['district']
    state = request.POST['state']
    numberofemployee = request.POST['noofemployee']
    phone = request.POST['phone']
    mobile = request.POST['mobile']
    email = request.POST['email']
    website = request.POST['website']
    status = request.POST['status']

    if 'logo' in request.FILES:
        logo=request.FILES['logo']
        from datetime import datetime
        date=datetime.now().strftime("%Y%m%d-%H%M%S")+'.jpg'
        fs=FileSystemStorage()
        fn=fs.save(date,logo)
        obj=Companies.objects.get(id=id)
        obj.logo=fs.url(date)
        obj.save()
        return HttpResponse('''<script>alert("Updated Successfully");window.location='/myapp/VIEW_PROFILE/'</script>''')

    if 'image1' in request.FILES:
        image1 = request.FILES['image1']
        from datetime import datetime
        date1= datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
        fs1 = FileSystemStorage()
        fn1 = fs1.save(date1, image1)
        obj = Companies.objects.get(id=id)
        obj.image1 = fs1.url(date1)
        obj.save()
        return HttpResponse('''<script>alert("Updated  Successfully");window.location='/myapp/VIEW_PROFILE/'</script>''')

    if 'image2' in request.FILES:
        image2 = request.FILES['image2']
        from datetime import datetime
        date2= datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
        fs2 = FileSystemStorage()
        fn2 = fs2.save(date2, image2)
        obj = Companies.objects.get(id=id)
        obj.image2 = fs2.url(date2)
        obj.save()
        return HttpResponse('''<script>alert("Updated  Successfully");window.location='/myapp/VIEW_PROFILE/'</script>''')

    if 'image3' in request.FILES:
        image3 = request.FILES['image3']
        from datetime import datetime
        date3= datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
        fs3 = FileSystemStorage()
        fn3 = fs3.save(date3, image3)
        obj = Companies.objects.get(id=id)
        obj.image3 = fs3.url(date3)
        obj.save()
        return HttpResponse('''<script>alert("Updated  Successfully");window.location='/myapp/VIEW_PROFILE/'</script>''')

    if 'certificate' in request.FILES:
        certificate = request.FILES['certificate']
        from datetime import datetime
        date4= datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
        fs4 = FileSystemStorage()
        fn4 = fs4.save(date4, certificate)
        obj = Companies.objects.get(id=id)
        obj.certificate = fs4.url(date4)
        obj.save()
        return HttpResponse('''<script>alert("Updated  Successfully");window.location='/myapp/VIEW_PROFILE/'</script>''')

    else:
        obj=Companies.objects.get(id=id)
        obj.name=name
        obj.building_number=building_number
        obj.place=place
        obj.post=post
        obj.since=since
        obj.pin=pin
        obj.district=district
        obj.state=state
        obj.numberofemployee=numberofemployee
        obj.phone=phone
        obj.mobile=mobile
        obj.email=email
        obj.website=website
        obj.status=status
        obj.save()
        return HttpResponse('''<script>alert("Registered Successfully");window.location='/myapp/VIEW_PROFILE/'</script>''')


def company_home(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:

        return render(request,'company/com index.html')


def COMPANY_CHANGE_PASS(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        return render(request,'company/COMPANY CHANGE PASS.html')
def COMPANY_CHANGE_PASS_post(request):
    oldpassword=request.POST['oldpassword']
    newpassword=request.POST['newpassword']
    confirmpassword=request.POST['confirmpassword']
    log=Login.objects.filter(password=oldpassword)
    if log.exists():
        log1 = Login.objects.get(password=oldpassword, id=request.session['lid'])
        if newpassword==confirmpassword:
            log1 = Login.objects.filter(password=oldpassword, id=request.session['lid']).update(password=confirmpassword)
            return HttpResponse('''<script>alert("changed successfully");window.location='/myapp/login/'</script>''')
        else :
            return HttpResponse('''<script>alert("Failed to change password");window.location='/myapp/login/'</script>''')
    else :
        return HttpResponse('''<script>alert("Failed to change password");window.location='/myapp/login/'</script>''')

def COMPANY_MANAGE_CATEGORY(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        res=Category.objects.all()
        return render(request,'company/COMPANY MANAGE CATEGORY.html',{'data':res})
def COMPANY_MANAGE_CATEGORY_post(request):
    category=request.POST['catadd']
    obj=Company_category()
    obj.CATEGORY_id=category
    obj.COMPANY=Companies.objects.get(LOGIN_id=request.session['lid'])
    obj.save()
    return HttpResponse('''<script>alert("ADDED SUCCESFULLY");window.location='/myapp/COMPANY_MANAGE_CATEGORY/'</script>''')




def COMPANYCATEGORY_VIEW(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Company_category.objects.filter(COMPANY__LOGIN_id=request.session['lid'])
        return render(request,'company/COMPANYCATEGORY VIEW.html',{'data':var})
def COMPANYCATEGORY_VIEW_post(request):
    search=request.POST['search']
    var = Company_category.objects.filter(COMPANY__LOGIN_id=request.session['lid'],CATEGORY__category_name__icontains=search)
    return render(request, 'company/COMPANYCATEGORY VIEW.html', {'data': var})
def COMPANY_CATEGORY_EDIT(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Company_category.objects.get(id=id)
        res=Category.objects.all()

        return render(request,'company/COMPANY CATEGORY EDIT.html',{'data':var,'data2':res})
def COMPANY_CATEGORY_EDIT_post(request):
    id=request.POST['id1']
    category_name=request.POST['catadd']
    var=Company_category.objects.get(id=id)
    var.CATEGORY_id=category_name
    var.save()

    return HttpResponse('''<script>alert("EDITED SUCCESFULLY");window.location='/myapp/COMPANYCATEGORY_VIEW/'</script>''')

def COMPANY_CATEGORY_DELETE(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Company_category.objects.get(id=id).delete()
        return HttpResponse('''<script>alert("DELETED SUCCESFULLY");window.location='/myapp/COMPANYCATEGORY_VIEW/'</script>''')




def COMPANY_MATERIALS_ADD(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var1=Category.objects.all()

        return render(request,'company/COMPANY MATERIALS ADD.html',{'data':var1})
def COMPANY_MATERIALS_ADD_post(request):
    name=request.POST['name']
    type=request.POST['type']
    price = request.POST['price']
    category = request.POST['select']
    photo=request.FILES['photo']
    from datetime import datetime
    date = datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
    fs = FileSystemStorage()
    fn = fs.save(date, photo)
    path=fs.url(date)
    obj=Material()
    obj.name=name
    obj.type=type
    obj.price=price
    obj.photo=path
    obj.CATEGORY_id=category
    obj.COMPANIES=Companies.objects.get(LOGIN=request.session['lid'])
    obj.save()
    return HttpResponse('''<script>alert("ADDED SUCCESFULLY");window.location='/myapp/COMPANY_MATERIALS_ADD/'</script>''')



def COMPANY_MATERIAL_VIEW(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Material.objects.filter(COMPANIES__LOGIN__id=request.session['lid'])
        return render(request,'company/COMPANY MATERIAL VIEW.html',{'data':var})

def COMPANY_MATERIAL_VIEW_post(request):
    search=request.POST['to']
    var=Material.objects.filter(COMPANIES__LOGIN__id=request.session['lid'],name__icontains=search)
    return render(request,'company/COMPANY MATERIAL VIEW.html',{'data':var})




def COMPANY_MATERIAL_EDIT(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var1=Category.objects.all()
        var=Material.objects.get(id=id)
        return render(request,'company/COMPANY MATERIAL EDIT.html',{'data':var,'data1':var1})
def COMPANY_MATERIAL_EDIT_post(request):
    id=request.POST['id']
    name=request.POST['name']
    type=request.POST['type']
    price = request.POST['price']
    category = request.POST['select']
    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        from datetime import datetime
        date = datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
        fs = FileSystemStorage()
        fn = fs.save(date, photo)
        obj=Material.objects.get(id=id)
        obj.photo=fs.url(date)
        return HttpResponse(
            '''<script>alert("EDITED SUCCESFULLY");window.location='/myapp/COMPANY_MATERIAL_VIEW/'</script>''')

    else:
        obj=Material.objects.get(id=id)
        obj.name=name
        obj.type=type
        obj.price=price
        obj.CATEGORY_id=category
        obj.save()
        return HttpResponse(
            '''<script>alert("EDITED SUCCESFULLY");window.location='/myapp/COMPANY_MATERIAL_VIEW/'</script>''')

def delete_Material(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        d=Material.objects.get(id=id)
        d.delete()
        return HttpResponse('''<script>alert("Deleted Successfully");window.location='/myapp/COMPANY_MATERIAL_VIEW/'</script>''')






def COMPANYSERVICEAND_FESS_ADDD(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        return render(request,'company/COMPANYSERVICEAND FESS ADDD.html')
def COMPANYSERVICEAND_FESS_ADDD_post(request):
    service=request.POST['service']
    feesperhour=request.POST['feesperhour']
    status=request.POST['select']
    obj=Service()
    obj.service=service
    obj.feesperhour=feesperhour
    com=Companies.objects.get(LOGIN=request.session['lid'])
    obj.LOGIN_id=com.LOGIN.id
    obj.status=status
    obj.save()
    return HttpResponse(
        '''<script>alert("ADDED SUCCESFULLY");window.location='/myapp/COMPANYSERVICEAND_FESS_ADDD/'</script>''')


def MANAGE_SERVICE_AND_FESS_VIEW(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Service.objects.filter(LOGIN__id=request.session['lid'])
        return render(request,'company/MANAGE SERVICE AND FESS VIEW.html',{'data':var})
def MANAGE_SERVICE_AND_FESS_VIEW_post(request):
    search=request.POST['to']
    var=Service.objects.filter(LOGIN__id=request.session['lid'],service__icontains=search)
    return render(request,'company/MANAGE SERVICE AND FESS VIEW.html',{'data':var})

def MANAGE_SERVICE_AND_FESS_EDIT(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Service.objects.get(id=id)
        return render(request,'company/MANAGE SERVICE AND FEES EDIT.html',{'data':var})
def MANAGE_SERVICE_AND_FESS_EDIT_post(request):
    id=request.POST['id']
    service=request.POST['name']
    feesperhour=request.POST['feesperhour']
    status=request.POST['select']
    var=Service.objects.get(id=id)
    var.service=service
    var.feesperhour=feesperhour
    var.status=status
    var.save()
    return HttpResponse(
        '''<script>alert("ADDED SUCCESFULLY");window.location='/myapp/MANAGE_SERVICE_AND_FESS_VIEW/'</script>''')

def delete_SERVICE_AND_FESS(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        d=Service.objects.get(id=id)
        d.delete()
        return HttpResponse('''<script>alert("Deleted Successfully");window.location='/myapp/MANAGE_SERVICE_AND_FESS_VIEW/'</script>''')



def view_company_review_on_plan(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        vr=Reviews.objects.filter(PLANS=id)
        request.session['pid']=id
        return render(request,'company/view company review on plan.html',{'data':vr})
def view_company_review_on_plan_post(request):
    frm = request.POST['from']
    to = request.POST['to']
    vr = Reviews.objects.filter(PLANS=request.session['pid'],date__range=[frm,to])
    return render(request, 'company/view company review on plan.html', {'data': vr})

def UPLOAD_PLAN_ADD(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        return render(request,'company/UPLOAD PLAN ADD.html')


def UPLOAD_PLAN_ADD_post(request):
    title=request.POST['title']
    description=request.POST['description']
    from datetime import datetime
    date=datetime.now().date().today()
    file=request.FILES['plan']
    from datetime import datetime
    date1 = datetime.now().strftime("%Y%m%d-%H%M%S") + '.jpg'
    fs = FileSystemStorage()
    fn = fs.save(date1, file)
    path=fs.url(date1)
    obj=Plans()
    obj.title=title
    obj.description=description
    obj.date=date
    obj.file=path
    comp=Companies.objects.get(LOGIN=request.session['lid'])

    obj.LOGIN_id=comp.LOGIN.id
    obj.save()
    return HttpResponse('''<script>alert("PLAN UPLOADED Successfully");window.location='/myapp/UPLOAD_PLAN_ADD/'</script>''')




def UPLOAD_PLAN_VIEW(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        # ob=Companies.objects.filter(LOGIN=request.session['lid'])
        var=Plans.objects.filter(LOGIN_id=request.session['lid'])
        return render(request,'company/UPLOAD PLAN VIEW.html',{'data':var})
def UPLOAD_PLAN_VIEW_post(request):
    frm=request.POST['from']
    to=request.POST['to']
    # ob=Companies.objects.get(LOGIN=request.session['lid'])
    var=Plans.objects.filter(LOGIN_id=request.session['lid'],date__range=[frm,to])
    return render(request,'company/UPLOAD PLAN VIEW.html',{'data':var})

def view_material_booking(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Book_main.objects.filter(COMPANIES__LOGIN_id=request.session['lid'])
        return render(request,'company/view material booking.html',{'data':var})

def view_material_booking_post(request):
    frm = request.POST['from']
    to = request.POST['to']
    var = Book_main.objects.filter(COMPANIES__LOGIN_id=request.session['lid'],date__range=[frm,to])
    return render(request, 'company/view material booking.html', {'data': var})


def view_material_booking_more(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Book_sub.objects.filter(BOOK_MAIN_id=id)
        return render(request,'company/view material booking more.html',{'data':var})

def view_service_booking(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        var=Service_Booking.objects.filter(SERVICE=id,status='pending')
        request.session['sid']=id
        return render(request,'company/view service booking.html',{'data':var})

def view_service_booking_post(request):
    frm = request.POST['from']
    to = request.POST['to']
    var = Service_Booking.objects.filter(SERVICE=request.session['sid'],date__range=[frm,to])
    return render(request, 'company/view service booking.html', {'data': var})


def view_review_rating(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        # oo=Companies.objects.get(LOGIN=request.session['lid'])
        var=Reviews.objects.filter(PLANS__LOGIN_id=request.session['lid'])
        return render(request,'company/review rating.html',{'data':var})


def view_review_rating_post(request):
    reviewfrom=request.POST['from']
    reviewto=request.POST['to']
    var=Reviews.objects.filter(date__range=[reviewfrom,reviewto],PLANS__LOGIN_id=request.session['lid'])
    return render(request,'company/review rating.html',{'data':var})

def approve_booking(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        res=Service_Booking.objects.filter(id=id).update(status='approved')
        return HttpResponse('''<script>alert("APPROVED");window.location='/myapp/view_approved_service_booking/'</script>''')

def reject_booking(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        res=Service_Booking.objects.filter(id=id).update(status='rejected')
        return HttpResponse('''<script>alert("REJECTED");window.location='/myapp/view_rejected_service_booking/'</script>''')

def view_approved_service_booking(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        res=Service_Booking.objects.filter(status='approved')
        return render(request,"company/view approved service booking.html",{'data':res})

def view_approved_service_booking_post(request):
    frmdt=request.POST['from']
    todt=request.POST['to']
    res=Service_Booking.objects.filter(status='approved',date__range=[frmdt,todt])
    return render(request,"company/view approved service booking.html",{'data':res})

def view_rejected_service_booking(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
    else:
        if request.session['lid']=='':
            return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')
        else:

            res=Service_Booking.objects.filter(status='rejected')
            return render(request,"company/view rejected service booking.html",{'data':res})

def view_rejected_service_booking_post(request):
    frmdt=request.POST['from']
    todt=request.POST['to']
    res=Service_Booking.objects.filter(status='rejected',date__range=[frmdt,todt])
    return render(request,"company/view rejected service booking.html",{'data':res})

def logout(request):
    request.session['lid']=''
    return HttpResponse('''<script>alert("LOGIN REQUIRED");window.location='/myapp/login/'</script>''')





###########################################################androidddd



###freelanceee




# def and_login(request):
#     username=request.POST['username']
#     password=request.POST['password']
#     log=Login.objects.filter(username=username,password=password)
#     if log.exists():
#         log1=Login.objects.get(username=username,password=password)
#         request.session['lid']=log1.id
#         if log1.type=='admin':
#             return JsonResponse({"status": "ok"})
#         elif log1.type=='company':
#             return JsonResponse({"status": "ok"})
#
#         else:
#             return JsonResponse({"status": "no"})
#     else:
#         return JsonResponse({"status": "no"})

def flutter_login_post(request):
    username = request.POST['username']
    password = request.POST['password']
    lobj = Login.objects.filter(username=username, password=password)
    if lobj.exists():
        lobjj = Login.objects.get(username=username, password=password)
        if lobjj.type == 'user':
            lid = lobjj.id
            return JsonResponse({'status':'ok', 'lid': str(lid),'type':'user'})
        elif lobjj.type == 'freelance' :
            lid = lobjj.id
            return JsonResponse({'status':'ok', 'lid': str(lid),'type':'freelance'})


        else:
            return JsonResponse({'status': 'no'})
    else:
        return JsonResponse({'status': 'no'})


def freechangepassword(request):
    oldpassword = request.POST['oldpassword']
    newpassword = request.POST['newpassword']
    confirmpassword = request.POST['confirmpassword']
    lid = request.POST['lid']

    log = Login.objects.filter(password=oldpassword)
    if log.exists():
        log1 = Login.objects.get(password=oldpassword, id=lid)
        if newpassword == confirmpassword:
            log1 = Login.objects.filter(password=oldpassword, id=lid).update(password=confirmpassword)
            return JsonResponse({"status": "ok"})
        else:
            return JsonResponse({"status": "no"})
    else:
        return JsonResponse({"status": "no"})


def freechatwithuser(request):
    return JsonResponse({"status":"ok"})

def freeeditprofile(request):
    lid=request.POST['lid']
    name=request.POST['name']
    gender=request.POST['gender']
    place=request.POST['place']
    post=request.POST['post']
    pin=request.POST['pin']
    district=request.POST['district']
    state=request.POST['state']
    phone=request.POST['phone']
    email=request.POST['email']
    website=request.POST['website']
    image=request.POST['photo']
    qualification=request.POST['qualification']
    experience=request.POST['experience']
    id_proof=request.POST['id_proof']


    if len(image)>5:

        import datetime
        import base64

        date = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
        a = base64.b64decode(image)
        # fh = open("C:\\Users\\ameer\\PycharmProjects\\D_HOMES\\media\\freelance\\" + date+".jpg", "wb")
        fh = open("C:\\Users\\ameer\\Saved Games\\PycharmProjects\\D_HOMES\\media\\freelance\\" + date + ".jpg", "wb")

        path = "/media/freelance/" + date + ".jpg"
        fh.write(a)
        fh.close()
        a = Freelancer.objects.get(LOGIN_id=lid)
        a.image = path
        a.save()

    a=Freelancer.objects.get(LOGIN_id=lid)
    a.name=name
    a.gender=gender
    a.place=place
    a.post=post
    a.pin=pin
    a.district=district
    a.state=state
    a.phone=phone
    a.email=email
    a.website=website
    a.qualification=qualification
    a.experience=experience
    a.id_proof=id_proof
    a.save()


    return JsonResponse({"status":"ok"})

def freemanageserviceandfees(request):
    lid=request.POST['lid']
    service=request.POST['service']
    feesperhour=request.POST['feesperhour']
    b=Service()
    b.service=service
    b.feesperhour=feesperhour
    b.LOGIN_id=lid
    b.status='Available'
    b.save()
    return JsonResponse({"status":"ok"})

def freeregistration(request):
    name=request.POST['name']
    gender=request.POST['gender']
    place=request.POST['place']
    post=request.POST['post']
    pin=request.POST['pin']
    district=request.POST['district']
    state=request.POST['state']
    phone=request.POST['phone']
    email=request.POST['email']
    website=request.POST['website']
    image=request.POST['image']
    qualification=request.POST['qualification']
    experience=request.POST['experience']
    id_proof=request.POST['id_proof']
    status=request.POST['status']
    password=request.POST['password']
    confirmpassword=request.POST['confirmpassword']


    from datetime import datetime


    date = datetime.now().strftime("%Y%m%d-%H%M%S")+".jpg"

    import base64

    a = base64.b64decode(image)
    fh = open("C:\\Users\\ameer\\Saved Games\\PycharmProjects\\D_HOMES\\media\\freelance\\" + date , "wb")

    path = "/media/freelance/" + date
    fh.write(a)
    fh.close()


    v=Login()
    v.username=email
    v.password=confirmpassword
    v.type='Pending'
    v.save()

    b=Freelancer()
    b.name = name
    b.gender = gender
    b.place = place
    b.post = post
    b.pin = pin
    b.district = district
    b.state = state
    b.phone = phone
    b.email = email
    b.website = website
    b.image = path
    b.qualification = qualification
    b.experience = experience
    b.id_proof = id_proof
    b.status='Pending'
    b.LOGIN=v
    b.save()




    return JsonResponse({"status":"ok"})

def freeuploadplans(request):
    lid=request.POST['lid']
    title=request.POST['title']
    description=request.POST['description']
    file=request.POST['file']
    from datetime import datetime


    date = datetime.now().strftime("%Y%m%d-%H%M%S")+".jpg"

    import base64

    a = base64.b64decode(file)
    fh = open("C:\\Users\\ameer\\Saved Games\\PycharmProjects\\D_HOMES\\media\\freelance\\" + date , "wb")

    path = "/media/freelance/" + date
    fh.write(a)
    fh.close()


    z=Plans()
    z.title=title
    z.description=description
    z.file=path
    from datetime import datetime
    z.date=datetime.now()
    z.LOGIN_id=lid
    z.save()


    return JsonResponse({"status":"ok"})


def freeviewbooking(request):
    lid=request.POST['lid']
    res=Service_Booking.objects.filter(SERVICE__LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({"id":i.id,"user":i.USER.name,"status":i.status,"date":i.date})
    return JsonResponse({"status":"ok"})

def freeviewplans(request):
    lid=request.POST['lid']
    res=Plans.objects.filter(LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({"id":i.id,"title":i.title,"description":i.description,"file":i.file,"date":i.date})
    return JsonResponse({"status":"ok",'data':l})

def freeviewprofile(request):
    lid=request.POST['lid']
    i=Freelancer.objects.get(LOGIN_id=lid)

    return JsonResponse({"status":"ok","id":i.id,"name":i.name,"gender":i.gender,
                        "place":i.place,"pin":i.pin,"district":i.district,
                         "state":i.state,"phone":i.phone,"post":i.post,"email":i.email,
                         "website":i.website,"photo":i.image,"qualification":i.qualification,
                         "experience":i.experience,"id_proof":str(i.id_proof)})

def freeviewreviewonplans(request):
    res=Reviews.objects.all()
    l=[]
    for i in res:
        l.append({"id":i.id,"review":i.review,"date":i.date,"rating":i.rating,"plans":i.PLANS.title,"user":i.USER.name})
    return JsonResponse({"status":"ok"})

def freeviewservicebooking(request):
    lid=request.POST['lid']
    res=Service_Booking.objects.filter(SERVICE__LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({"id":i.id,"service":i.SERVICE.service,"status":i.status,"date":i.date,"user":i.USER.name,'lid':i.USER.LOGIN.id})
    print(l)
    return JsonResponse({"status":"ok",'data':l})
def freeviewservicefee(request):
    lid=request.POST['lid']
    res=Service.objects.filter(LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({"id":i.id,"service":i.service,"status":i.status,"feesperhour":i.feesperhour})
    return JsonResponse({"status":"ok",'data':l})


def free_editview_view(request):
    qid=request.POST['qid']
    i=Service.objects.get(id=qid)
    return JsonResponse({'status': 'ok','id':i.id,'service':i.service,'feesperhour':i.feesperhour,'Status':i.status})

def freee_edit_slot(request):
    lid = request.POST["lid"]
    qid=request.POST['qid']
    slot = request.POST["service"]
    price = request.POST["feesperhour"]
    s = request.POST["status"]

    cobj = Service.objects.get(id=qid)
    cobj.service = slot
    cobj.feesperhour = price
    cobj.status = s
    cobj.LOGIN_id = lid
    cobj.save()
    return JsonResponse({'status': 'ok'})



from django.http import JsonResponse

def delete_slot(request):
    try:

        tid = request.POST['tid']
        slot = Service.objects.get(id=tid)
        slot.delete()
        return JsonResponse({'status': 'ok'})
    except Service.DoesNotExist:
        return JsonResponse({'status': 'error', 'message': 'Service not found'})
from django.http import JsonResponse

def delete_plan(request):
    try:

        tid = request.POST['tid']
        slot = Plans.objects.get(id=tid)
        slot.delete()
        return JsonResponse({'status': 'ok'})
    except Service.DoesNotExist:
        return JsonResponse({'status': 'error', 'message': 'Service not found'})


######userrrrr




def useraddproducttocart(request):
    MATERIAL=request.POST('MATERIAL')
    lid=request.POST['lid']
    quantity=request.POST('quantity')
    t=Cart()
    t.quantity=quantity
    t.save()
    return JsonResponse({"status":"ok"})

def userchangepassword(request):
    oldpassword = request.POST['oldpassword']
    newpassword = request.POST['newpassword']
    confirmpassword = request.POST['confirmpassword']
    lid= request.POST['lid']

    log = Login.objects.filter(password=oldpassword)
    if log.exists():
        log1 = Login.objects.get(password=oldpassword, id=lid)
        if newpassword == confirmpassword:
            log1 = Login.objects.filter(password=oldpassword, id=lid).update(
                password=confirmpassword)
            return JsonResponse({"status": "ok"})
        else:
            return JsonResponse({"status": "no"})

    else:
        return JsonResponse({"status":"no"})

def userchatwithcompany(request):
    return JsonResponse({"status":"ok"})

def userchatwithfreelance(request):
    return JsonResponse({"status":"ok"})

def usercompanyservicebooking(request):
    lid=request.POST['lid']
    res=Service_Booking.objects.filter(USER__LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({"id":i.id,"status":i.status,"date":i.date})
    return JsonResponse({"status":"ok"})
def usercompanyservices(request):

    res=Service.objects.all()
    l=[]
    for i in res:
        l.append({"id":i.id,"service":i.service,"feesperhour":i.feesperhour,'name':i.LOGIN.username})
    return JsonResponse({"status":"ok",'data':l})


def bookservice(request):
    lid=request.POST['lid']
    sid=request.POST['sid']
    from datetime import datetime
    date=datetime.now().date().today()
    status='pending'
    r=Service_Booking.objects.filter(SERVICE_id=sid,USER__LOGIN_id=lid)
    if r.exists():
        return JsonResponse({"status": "no"})
    else:
        obj =Service_Booking()
        obj.status='pending'
        obj.date=date
        obj.USER=User.objects.get(LOGIN_id=lid)
        obj.SERVICE_id=sid
        obj.save()
        return JsonResponse({"status": "ok"})




def usereditprofile(request):
    lid=request.POST['lid']
    name=request.POST['name']
    # gender=request.POST['gender']
    place=request.POST['place']
    post=request.POST['post']
    pin=request.POST['pin']
    district=request.POST['district']
    state=request.POST['state']
    phone=request.POST['phone']
    email=request.POST['email']
    image=request.POST['photo']


    if len(image)>5:

        import datetime
        import base64

        date = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
        a = base64.b64decode(image)
        fh = open("C:\\Users\\ameer\\Saved Games\\PycharmProjects\\D_HOMES\\media\\user\\" + date +".jpg", "wb")

        path = "/media/user/" + date + ".jpg"
        fh.write(a)
        fh.close()
        a = User.objects.get(LOGIN_id=lid)
        a.image = path
        a.save()

    a=User.objects.get(LOGIN_id=lid)
    a.name=name
    # a.gender=gender
    a.place=place
    a.post=post
    a.pin=pin
    a.district=district
    a.state=state
    a.phone=phone
    a.email=email
    a.save()


    return JsonResponse({"status":"ok"})



def userregister(request):
    name = request.POST['name']
    place = request.POST['place']
    post = request.POST['post']
    pin = request.POST['pin']
    district = request.POST['district']
    state = request.POST['state']
    phone = request.POST['phone']
    email = request.POST['email']
    photo = request.POST['image']
    password = request.POST['password']
    confirmpassword = request.POST['confirmpassword']


    from datetime import datetime


    date = datetime.now().strftime("%Y%m%d-%H%M%S")+".jpg"

    import base64

    a = base64.b64decode(photo)
    fh = open("C:\\Users\\ameer\\Saved Games\\PycharmProjects\\D_HOMES\\media\\user\\" + date + ".jpg" , "wb")

    path = "/media/user/" + date+".jpg"
    fh.write(a)
    fh.close()




    v = Login()
    v.username = email
    v.password = confirmpassword
    v.type = 'user'
    v.save()
    b = User()
    b.name = name
    b.place = place
    b.post = post
    b.pin = pin
    b.district = district
    b.state = state
    b.phone = phone
    b.email = email
    b.photo = path
    b.LOGIN = v
    b.save()

    return JsonResponse({"status":"ok"})

def usersendcomplaints(request):
    complaint = request.POST['complaint']
    lid=request.POST['lid']

    g=Complaints()
    g.complaint=complaint
    g.replay='pending'
    g.status='pending'
    g.USER=User.objects.get(LOGIN_id=lid)
    from datetime import datetime
    g.date=datetime.now().strftime('%Y-%m-%d')
    g.save()


    return JsonResponse({"status":"ok"})

def usersendfeedback(request):
    feedback = request.POST['feedback']
    lid = request.POST['lid']
    f=Feedback()
    f.feedback=feedback
    from datetime import datetime
    f.date=datetime.now().strftime('%Y-%m-%d')
    f.USER=User.objects.get(LOGIN_id=lid)
    f.save()
    return JsonResponse({"status":"ok"})

def usersendreviewonplans(request):
    review = request.POST['review']
    plans = request.POST['plans']
    rating = request.POST['rating']
    lid = request.POST['lid']
    s= Reviews()
    s.review = review
    from datetime import datetime
    s.date = datetime.now().strftime('%Y-%m-%d')
    s.USER = User.objects.get(LOGIN_id=lid)
    s.PLANS_id=plans
    s.rating_id=rating

    s.save()
    return JsonResponse({"status":"ok"})

def userviewcart(request):
    lid=request.POST['lid']
    res = Cart.objects.filter(USER__LOGIN_id=lid)
    l = []
    for i in res:
        l.append({"id": i.id, "name": i.MATERIAL.name,"price": i.MATERIAL.price,"photo": i.MATERIAL.photo, "quantity": i.quantity, })
    return JsonResponse({"status": "ok",'data':l})


def userviewcompany(request):
    # lid = request.POST['lid']
    res = Companies.objects.filter(status='approved')
    l = []
    for i in res:
        l.append({"id": i.id, "name": i.name,"phone": i.phone,"email": i.email,'lid':i.LOGIN.id})


    return JsonResponse({"status": "ok", 'data': l})
# def userviewcompany(request):
#     # lid = request.POST['lid']
#     res = Companies.objects.filter(status='approved')
#     l = []
#     for i in res:
#         l.append({"id": i.id, "name": i.name, "image1": i.image1,
#                   "building_number": i.building_number,"place": i.place,"post": i.post,"since": i.since,
#                   "pin": i.pin, "district": i.district,"state": i.state,"numberofemployee": i.numberofemployee,
#                   "logo": i.logo,"phone": i.phone,"email": i.email})
#     return JsonResponse({"status": "ok", 'data': l})

def userviewcompanymaterials(request):
    mid=request.POST['mid']
    res=Material.objects.filter(COMPANIES_id=mid)
    l=[]
    for i in res:
        l.append({"id":i.id,"name":i.name,"type":i.type,"price":i.price,"photo":i.photo})
    print(l)
    return JsonResponse({"status":"ok",'data':l})

# def userviewnearbycompanies(request):
#     res = location.objects.all()
#     l = []
#     for i in res:
#         l.append({"id": i.id, "latitude": i.latitude, "longitude": i.longitude, "time": i.time, "date": i.date,"LOGIN": i.LOGIN.id})
#     return JsonResponse({"status": "ok" ,'data': l})
#
# def userviewnearbyfreelance(request):
#     res = location.objects.all()
#     l = []
#     for i in res:
#         l.append({"id": i.id, "latitude": i.latitude, "longitude": i.longitude, "time": i.time, "date": i.date,
#                   "LOGIN": i.LOGIN.id})
#     return JsonResponse({"status": "ok", 'data': l})


def userviewplans(request):
    res=Plans.objects.all()
    l=[]
    for i in res:
        l.append({"id":i.id,"title":i.title,"description":i.description,"file":i.file,"date":i.date})
    return JsonResponse({"status":"ok"})

def userviewprofile(request):
    lid=request.POST['lid']
    i=User.objects.get(LOGIN_id=lid)
    return JsonResponse({"status":"ok","name":i.name,"place":i.place,"post":i.post,"pin":i.pin,
                         "district":i.district,"state":i.state,"phone":i.phone,"email":i.email,"photo":i.photo})

def userviewreplyoncopmplaints(request):
    lid=request.POST['lid']
    res=Complaints.objects.filter(USER__LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({"id":i.id,"complaint":i.complaint,"reply":i.replay,"date":i.date,"status":i.status})
    return JsonResponse({"status":"ok"})

def userviewreviewonplans(request):
    lid=request.POST['lid']
    res=Reviews.objects.filter(USER__LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({"id":i.id,"":i.review,"date":i.date,"rating":i.rating,
                  "plan":i.PLANS.title})
    return JsonResponse({"status":"ok"})




def user_update_location(request):
    print(request.POST)
    lid=request.POST['lid']
    type=request.POST['type']
    latitude=request.POST['latitude']
    longitude=request.POST['longitude']
    if type == 'user':
        if UserLocation.objects.filter(USER__LOGIN_id=lid):
            var = UserLocation.objects.get(USER__LOGIN_id=lid)
            var.latitude = latitude
            var.longitude = longitude
            var.USER = User.objects.get(LOGIN_id=lid)
            var.save()
            return JsonResponse({"status": "ok"})

        var = UserLocation()
        var.latitude = latitude
        var.longitude = longitude
        var.USER = User.objects.get(LOGIN_id=lid)
        var.save()
        return JsonResponse({"status": "ok"})
    else:
        if Location.objects.filter(EV__LOGIN_id=lid):
            var = Location.objects.get(EV__LOGIN_id=lid)
            var.latitude = latitude
            var.longitude = longitude
            var.EV = Freelancer.objects.get(LOGIN_id=lid)
            var.save()
            return JsonResponse({"status": "ok"})


        var = Location()
        var.latitude = latitude
        var.longitude = longitude
        var.EV = Freelancer.objects.get(LOGIN_id=lid)
        var.save()
        return JsonResponse({"status": "ok"})

def user_view_freelancers(request):
    f=Freelancer.objects.all()
    l=[]
    for i in f:
        l.append(
            {
                'id':i.id,
                'lid':i.LOGIN.id,
                'name':i.name,
                'email':i.email,
                'image':i.image,
                'phone':i.phone,
            }
        )
    return  JsonResponse(
        {
            'status':'ok',
            'data':l
        }
    )

def user_view_freelancer_services(request):
    fid= request.POST["fid"]

    fobj= Freelancer.objects.get(id=fid)





    s=Service.objects.filter(LOGIN_id= fobj.LOGIN.id)



    ls=[]

    for i in s:

        ls.append(
            {
                'id': i.id,
                'service': i.service,
                'feesperhour': i.feesperhour,
            }
        )

    return  JsonResponse(
        {
            'status':'ok',
            'data':ls
        }
    )


def user_service_booking(request):
    lid= request.POST["lid"]
    sid= request.POST["sid"]

    from datetime import  datetime

    r = Service_Booking.objects.filter(SERVICE_id=sid, USER__LOGIN_id=lid)
    if r.exists():
        return JsonResponse({"status": "no"})
    else:
        obj = Service_Booking()
        obj.status = 'pending'
        obj.date = datetime.now().date()
        obj.USER = User.objects.get(LOGIN_id=lid)
        obj.SERVICE_id = sid
        obj.save()
        return JsonResponse({"status": "ok"})


def user_Sent_feedback(reqquest):

    lid= reqquest.POST["lid"]
    feedback= reqquest.POST["feedback"]
    from  datetime import  datetime
    f=Feedback()
    f.USER= User.objects.get(LOGIN_id=lid)
    f.feedback= feedback
    f.date = datetime.now()
    f.save()

    return  JsonResponse(
        {
            'status':'ok'
        }
    )



def user_view_plans(request):
    cid= request.POST["lid"]

    c=Companies.objects.get(id= cid)

    p= Plans.objects.filter(LOGIN_id= c.LOGIN.id)

    l=[]

    for i in p:

        l.append(
            {
                'id': i.id,
                'title': i.title,
                'description': i.description,
                'file': i.file,
                'date': i.date,
            }
        )

    print(l)

    return  JsonResponse(
        {
            'status':'ok',
            'data':l
        }
    )




def user_view_plans_of_frelancer(request):
    cid= request.POST["lid"]



    p= Plans.objects.filter(LOGIN_id=cid)

    l=[]

    for i in p:

        l.append(
            {
                'id': i.id,
                'title': i.title,
                'description': i.description,
                'file': i.file,
                'date': i.date,
            }
        )

    print(l)

    return  JsonResponse(
        {
            'status':'ok',
            'data':l
        }
    )



def user_addto_cart(request):


    lid= request.POST["lid"]
    mid= request.POST["mid"]
    qid= request.POST["qty"]

    c=Cart()
    c.USER= User.objects.get(LOGIN_id= lid)
    c.MATERIAL_id=mid
    c.quantity=qid
    c.save()

    return  JsonResponse(
        {
            'status':'ok'
        }
    )


def user_view_cart(request):
    lid= request.POST["lid"]
    c=Cart.objects.filter(USER__LOGIN_id=lid)
    l=[]
    amnt=0
    for i in c:
        amnt += int(i.quantity) * int(i.MATERIAL.price)
        l.append(
            {
                'quantity':i.quantity,
                'name':i.MATERIAL.name,
                'price':i.MATERIAL.price,
                'photo':i.MATERIAL.photo,
                'id':i.id
            }
        )
    return JsonResponse(
        {
            'status':'ok',
            'data':l,
            'amount':amnt
        }
    )


def deletefromcart(request):

    cid= request.POST["cid"]

    Cart.objects.filter(id=cid).delete()

    return  JsonResponse(
        {
            'status':'ok'
        }

    )


def cartpayment(request):
    lid= request.POST["lid"]

    c=Cart.objects.filter(USER__LOGIN_id=lid)

    cids=[]

    for i in c:
        if i.MATERIAL.COMPANIES.id not in cids:
            cids.append(i.MATERIAL.COMPANIES.id)
    from datetime import  datetime
    for i in cids:
        c = Cart.objects.filter(USER__LOGIN_id=lid,MATERIAL__COMPANIES_id=i)

        b=Book_main()
        b.USER= User.objects.get(LOGIN_id=lid)
        b.date= datetime.now()
        b.amount="0"
        b.COMPANIES_id=i
        b.save()


        amts=0
        for i in c:
            bb=Book_sub()
            bb.quantity= i.quantity
            bb.MATERIAL=i.MATERIAL
            bb.BOOK_MAIN= b
            bb.save()

            amts = amts + ( float(i.quantity) * float(i.MATERIAL.price) )

        b.amount= str(amts)
        b.save()



    return  JsonResponse(
        {
            'status':'ok'
        }
    )




def user_view_material_order(request):
    
    lid= request.POST["lid"]
    
    s=Book_main.objects.filter(USER= User.objects.get(LOGIN_id=lid))
    
    l=[]
    
    for i in s:
        
        l.append(
            {
                'id':i.id,
                'date':i.date,
                'amount':i.amount,
                'cname':i.COMPANIES.name,
                'place':i.COMPANIES.place,
                'mobile':i.COMPANIES.mobile,
                
                
                
            }
        )

    return  JsonResponse(
        {
            'status':'ok',
            'data':l
        }
    )


def user_view_order_sub(request):
    oid= request.POST["oid"]



    o=Book_sub.objects.filter(BOOK_MAIN_id=oid)


    l=[]

    for i in o:

        l.append(
            {
                'id':i.id,
                'quantity':i.quantity,
                'name':i.MATERIAL.name,
                'price':i.MATERIAL.price,
            }
        )

    return  JsonResponse(
        {
            'status':'ok',
            'data':l
        }
    )


def user_view_freelancer_booking(request):
    lid= request.POST["lid"]
    s=Service_Booking.objects.filter(USER__LOGIN_id= lid)
    l=[]

    for i in s:

        l.append(
            {
                'id':i.id,
                'date':i.date,
                'service':i.SERVICE.service,
                'feesperhour':i.SERVICE.feesperhour,
                'status':i.status,
                'amount':i.amount,
            }
        )

    return  JsonResponse(
        {
            'status':'ok',
            'data':l
        }
    )


def user_add_review(request):

    lid= request.POST["lid"]
    review= request.POST["review"]
    rating= request.POST["rating"]
    planid= request.POST["planid"]

    from datetime import  datetime

    r=Reviews()
    r.USER= User.objects.get(LOGIN_id=lid)
    r.PLANS_id= planid
    r.date= datetime.now()
    r.review=review
    r.rating=rating
    r.save()

    return  JsonResponse(
        {
            'status':'ok'
        }
    )




def user_view_reviews_on_plan(request):
    pid= request.POST["pid"]


    r=Reviews.objects.filter(PLANS_id=pid)

    l=[]

    for i in r:

        l.append(
            {
                'id':i.id,
                'review': i.review,
                'date':i.date,
                'rating': i.rating,
                'name':i.USER.name,
                'email':i.USER.email,
                'photo':i.USER.photo,

            }
        )


    return  JsonResponse(
        {
            'status':'ok',
            'data':l
        }
    )


def staff_sendchat(request):
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
    c.date=datetime.now()
    c.save()
    return JsonResponse({'status':"ok"})


def staff_viewchat(request):
    fromid = request.POST["from_id"]
    toid = request.POST["to_id"]
    # lmid = request.POST["lastmsgid"]
    from django.db.models import Q

    res = Chat.objects.filter(Q(FROMID_id=fromid, TOID_id=toid) | Q(FROMID_id=toid, TOID_id=fromid))
    l = []

    for i in res:
        l.append({"id": i.id, "msg": i.message, "from": i.FROMID_id, "date": i.date, "to": i.TOID_id})

    return JsonResponse({"status":"ok",'data':l})






def freelanceraddamount(request):
    amount = request.POST['amount']
    sid = request.POST['mid']
    rs=Service_Booking.objects.filter(id=sid).update(status='accepted',amount=amount)
    return JsonResponse({"status": "ok"})




def chat1(request,id):
    request.session["userid"] = id
    cid = str(request.session["userid"])
    request.session["new"] = cid
    qry = User.objects.get(LOGIN=cid)

    return render(request, "company/Chat.html", {'photo': qry.photo, 'name': qry.name, 'toid': cid})

def chat_view(request):
    fromid = request.session["lid"]
    toid = request.session["userid"]
    qry = User.objects.get(LOGIN=request.session["userid"])
    from django.db.models import Q

    res = Chat.objects.filter(Q(FROMID_id=fromid, TOID_id=toid) | Q(FROMID_id=toid, TOID_id=fromid))
    l = []

    for i in res:
        l.append({"id": i.id, "message": i.message, "to": i.TOID_id, "date": i.date, "from": i.FROMID_id})

    return JsonResponse({'photo': qry.photo, "data": l, 'name': qry.name, 'toid': request.session["userid"]})

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
    chatobt.save()

    return JsonResponse({"status": "ok"})


def forget_password(request):
    return render(request,'forgotpassword.html')

def forget_password_post(request):
    em = request.POST['em_add']
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
        return HttpResponse('<script>alert("success");window.location="/myapp/login/"</script>')
    else:
        return HttpResponse('<script>alert("invalid email");window.location="/myapp/login/"</script>')
