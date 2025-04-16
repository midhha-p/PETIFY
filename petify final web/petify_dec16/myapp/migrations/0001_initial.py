# Generated by Django 3.0 on 2025-03-11 11:38

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Delivery_boy',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('phone_no', models.BigIntegerField()),
                ('bike_no', models.CharField(max_length=20)),
                ('bike_details', models.CharField(max_length=100)),
                ('photo', models.CharField(max_length=100)),
                ('email', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Grooming',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('grooming_name', models.CharField(max_length=100)),
                ('grooming_price', models.BigIntegerField()),
                ('package_details', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Login',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('username', models.CharField(max_length=100)),
                ('password', models.CharField(max_length=100)),
                ('type', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Order_Main',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateField()),
                ('status', models.CharField(max_length=100)),
                ('amount', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Pet',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('photo', models.CharField(max_length=100)),
                ('breed', models.CharField(max_length=100)),
                ('age', models.BigIntegerField()),
                ('description', models.CharField(max_length=100)),
                ('price', models.BigIntegerField()),
                ('gender', models.CharField(max_length=100)),
                ('type', models.CharField(default='', max_length=100)),
                ('addtype', models.CharField(default='', max_length=100)),
                ('LOGIN', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Login')),
            ],
        ),
        migrations.CreateModel(
            name='Pet_Order_Main',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateField()),
                ('status', models.CharField(max_length=100)),
                ('amount', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Pet_products',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('product_name', models.CharField(max_length=100)),
                ('photo', models.CharField(max_length=100)),
                ('description', models.CharField(max_length=100)),
                ('price', models.BigIntegerField()),
                ('type', models.CharField(default='', max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Vets',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('Clinic', models.CharField(max_length=100)),
                ('Location', models.CharField(max_length=100)),
                ('photo', models.CharField(max_length=100)),
                ('Latitude', models.CharField(max_length=100)),
                ('Longitude', models.CharField(max_length=100)),
                ('Phone_Number', models.CharField(max_length=100)),
                ('Email', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('username', models.CharField(max_length=100)),
                ('email', models.CharField(max_length=100)),
                ('phone_no', models.BigIntegerField()),
                ('place', models.CharField(max_length=100)),
                ('dob', models.DateField()),
                ('gender', models.CharField(max_length=100)),
                ('photo', models.CharField(max_length=100)),
                ('city', models.CharField(max_length=100)),
                ('state', models.CharField(max_length=100)),
                ('pincode', models.CharField(max_length=100)),
                ('LOGIN', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Login')),
            ],
        ),
        migrations.CreateModel(
            name='Review',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('review', models.CharField(max_length=100)),
                ('rating', models.CharField(max_length=100)),
                ('date', models.DateField()),
                ('USER', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.User')),
            ],
        ),
        migrations.CreateModel(
            name='Products_Cart',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('Quantity', models.CharField(max_length=100)),
                ('PET_PRODUCTS', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_products')),
                ('USER', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.User')),
            ],
        ),
        migrations.CreateModel(
            name='Pet_shop',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('shopname', models.CharField(max_length=100)),
                ('place', models.CharField(max_length=100)),
                ('post', models.CharField(max_length=100)),
                ('phone_no', models.BigIntegerField()),
                ('email', models.CharField(max_length=100)),
                ('photo', models.CharField(max_length=100)),
                ('status', models.CharField(max_length=100)),
                ('LOGIN', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Login')),
            ],
        ),
        migrations.CreateModel(
            name='Pet_Review',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('review', models.CharField(max_length=100)),
                ('rating', models.CharField(max_length=100)),
                ('date', models.DateField()),
                ('PET', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet')),
                ('USER', models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='myapp.User')),
            ],
        ),
        migrations.AddField(
            model_name='pet_products',
            name='SHOPNAME',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_shop'),
        ),
        migrations.CreateModel(
            name='Pet_Payment',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status', models.CharField(max_length=100)),
                ('amount', models.CharField(max_length=100)),
                ('date', models.DateField()),
                ('PET_ORDER_MAIN', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_Order_Main')),
                ('USER', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.User')),
            ],
        ),
        migrations.CreateModel(
            name='Pet_Order_Sub',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('quantity', models.BigIntegerField()),
                ('PET', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet')),
                ('PET_ORDER_MAIN', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_Order_Main')),
            ],
        ),
        migrations.AddField(
            model_name='pet_order_main',
            name='SHOPNAME',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_shop'),
        ),
        migrations.AddField(
            model_name='pet_order_main',
            name='USER',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.User'),
        ),
        migrations.CreateModel(
            name='Pet_Cart',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('Quantity', models.CharField(max_length=100)),
                ('PET', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet')),
                ('USER', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.User')),
            ],
        ),
        migrations.CreateModel(
            name='Pet_assign_Delivery_boy',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateField()),
                ('status', models.CharField(max_length=100)),
                ('DELIVERY_BOY', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Delivery_boy')),
                ('ORDER_MAIN', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_Order_Main')),
            ],
        ),
        migrations.CreateModel(
            name='Payment',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status', models.CharField(max_length=100)),
                ('amount', models.CharField(max_length=100)),
                ('date', models.DateField()),
                ('ORDER_MAIN', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Order_Main')),
                ('USER', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.User')),
            ],
        ),
        migrations.CreateModel(
            name='Order_Sub',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('quantity', models.BigIntegerField()),
                ('ORDER_MAIN', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Order_Main')),
                ('PET_PRODUCTS', models.ForeignKey(default='', on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_products')),
            ],
        ),
        migrations.AddField(
            model_name='order_main',
            name='SHOPNAME',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_shop'),
        ),
        migrations.AddField(
            model_name='order_main',
            name='USER',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.User'),
        ),
        migrations.CreateModel(
            name='Grooming_Request',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateField()),
                ('status', models.CharField(max_length=100)),
                ('paystatus', models.CharField(max_length=100)),
                ('GROOMING', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Grooming')),
                ('USER', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.User')),
            ],
        ),
        migrations.AddField(
            model_name='grooming',
            name='SHOPNAME',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_shop'),
        ),
        migrations.CreateModel(
            name='groom_Payment',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status', models.CharField(max_length=100)),
                ('amount', models.CharField(max_length=100)),
                ('date', models.DateField()),
                ('GROOMING_REQUEST', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Grooming_Request')),
                ('USER', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.User')),
            ],
        ),
        migrations.CreateModel(
            name='Disease',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('disease_name', models.CharField(max_length=100)),
                ('image', models.CharField(max_length=100)),
                ('description', models.CharField(max_length=100)),
                ('remedy', models.CharField(max_length=100)),
                ('SHOPNAME', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Pet_shop')),
            ],
        ),
        migrations.AddField(
            model_name='delivery_boy',
            name='LOGIN',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Login'),
        ),
        migrations.CreateModel(
            name='Chat',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateField()),
                ('time', models.TimeField()),
                ('message', models.CharField(max_length=100)),
                ('FROMID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='from_id', to='myapp.Login')),
                ('TOID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='to_id', to='myapp.Login')),
            ],
        ),
        migrations.CreateModel(
            name='Assign_Deliery_boy',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateField()),
                ('status', models.CharField(max_length=100)),
                ('DELIVERY_BOY', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Delivery_boy')),
                ('ORDER_MAIN', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.Order_Main')),
            ],
        ),
    ]
