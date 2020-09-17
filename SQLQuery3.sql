
insert into sube (subeID, subeAdi, ilID,ilceID,subeAdres,subeTelefon)
values ('6','Sube6','1','2','Atýk Caddesi','02127641789')
--yeni açýlan þube sisteme kayýt edilir.


insert into personel (personelID,personelAd,personelSoyad,personelTCNo,personelDogumYili,personelTelefon,personelIkametgah,subeID,personelYetkileriID,gorevID) 
values ('22','Mehmet','Kanmaz','27279467289','1985','05394527846','Baþakþehir','6','3','3')
--yeni açýlan þubeye yeni bir genel müdür alýmý yapýlýr ve sisteme kayýt edilir.

  
update personel set subeID=6 where personelID=13
--2.þubede olan Ebru Çetin tecrübeli olduðundan Müdür yardýmcýsý olarak 6.Þubeye transfer olmuþtur ve sisteme kayýt edilir.


insert into personel (personelID,personelAd,personelSoyad,personelTCNo,personelDogumYili,personelTelefon,personelIkametgah,subeID,personelYetkileriID,gorevID) 
values ('27','Esma','Sonar','27125467289','1996','05394593421','Davutpaþa','6','5','5')

insert into personel (personelID,personelAd,personelSoyad,personelTCNo,personelDogumYili,personelTelefon,personelIkametgah,subeID,personelYetkileriID,gorevID) 
values ('28','Alihan','Yener','27298457289','1997','05326749835','Bahçelievler','6','5','5')

insert into personel (personelID,personelAd,personelSoyad,personelTCNo,personelDogumYili,personelTelefon,personelIkametgah,subeID,personelYetkileriID,gorevID) 
values ('29','Ayþenur','Konak','27279469834','2000','05319853672','Esenler','6','5','5')
--Açýlan yeni þubeye yeni personel alýmý ve sistemde görev yetkilendirilmesi

--PERSONEL GÖREV YETKÝ SORGULARI
select p.personelAd,p.personelSoyad, g.gorevAdi,gy.Yetkiler from personelYetkileri py
inner join personel p on p.gorevID=py.gorevID
inner join gorev g on g.gorevID=py.gorevID
inner join gorevYetki gy on gy.gorevYetkileriID= py.gorevYetkileriID order by personelAd,personelSoyad
--Her personelin sistemdeki görev adlarý ve yetkileri


insert into coksatis (satisID,urunID,personelID,satisFiyati,satisMiktari,subeID,satisTutari,satisTarihi) 
values ('54','1','29','20','5','6','100','06-06-2020')
--Þubelerin ürün bazlý satýþ rakamlarýnýn sisteme aktarýlmasý sorgusu


insert into personelHedef (personelHedefID, personelID, subeID, personelHedef)
values ('18','29','6','3000')
--Personel satýþ hedefinin girilmesi sorgusu


update personelHedef set personelHedef=2000 where personelID=27
--Personel satýþ hedefinin sistemde düzeltilmesi


--PERSONEL SATIÞ SORGULARI
select  p.subeID, p.personelAd, p.personelSoyad,s.satisMiktari ,s.satisFiyati,s.satisTarihi from  personel p 
inner join coksatis s on p.personelID=s.personelID order by satisTarihi
--Tarih bazlý personellerin satýþ miktarý ve birim satýþ fiyatý

select cs.satisTarihi,  sum(cs.satisTutari) günlüksatis  from coksatis cs group by satisTarihi
--Her gün yapýlan satýþ toplamý

select p.personelID,p.personelAd,p.personelSoyad, sum(s.satisTutari) satisTutari, ph.personelHedef from coksatis s 
inner join personelHedef ph on s.personelID=ph.personelID
inner join personel p on s.personelID=p.personelID
group by ph.personelHedef,p.personelID,p.personelAd,p.personelSoyad
--Her bir personelin hedefi ve satýþlarý

select p.personelID,p.personelAd,p.personelSoyad,ph.personelHedef, sum(s.satisTutari) toplamsatis from personel p
inner join personelHedef ph on ph.personelID=p.personelID 
inner join coksatis s on s.personelID= p.personelID
group by p.personelID,ph.personelHedef,p.personelAd,p.personelSoyad
having ph.personelHedef< sum(s.satisTutari)
--!!Personel belirlenen hedefe ulaþtý mý?
--Baþarýlý personellerin belirlenmesi


select p.personelAd,p.personelSoyad, s.subeAdi, il.subeIl  ,ilce.subeIlce,sum(cs.satisTutari) satisTutari from sube s
inner join personel p on s.subeID=p.subeID
inner join ilceTablosu ilce on ilce.ilceID=s.ilceID
inner join ilTablosu il on il.ilID=s.ilID
inner join coksatis cs on cs.personelID=p.personelID
group by personelAd,personelSoyad,s.subeAdi, il.subeIl  ,ilce.subeIlce
--her bir personelin satýþýný subeleri ve ilçeleriyle beraber görülmesi


select s.subeID,s.subeAdi, il.subeIl  ,ilce.subeIlce,sh.subeHedef,sum(cs.satisTutari) subesatis from sube s
inner join personel p on s.subeID=p.subeID
inner join ilceTablosu ilce on ilce.ilceID=s.ilceID
inner join ilTablosu il on il.ilID=s.ilID
inner join coksatis cs on cs.personelID=p.personelID
inner join subeHedef sh on sh.subeID=s.subeID
group by s.subeID,s.subeAdi, il.subeIl  ,ilce.subeIlce,sh.subeHedef
--!!Þube il ve ilçeleriyle belirlenen hedefe ulaþtý mý?


--SEVKÝYAT SORGULARI
select u.urunAdi,se.siparisDurumu ,se.sevkiyatTeslimTarihi  from urun u
inner join subeDepo sd on sd.urunID= u.urunID
inner join anaDepo a on a.urunID=u.urunID
inner join sevkiyat se on se.urunID=u.urunID where se.siparisDurumu='Hazýrlanýyor'
--!!Ürünlerin tarihlere göre sipariþ durumu


select  s.subeAdi, u.urunAdi,sum(sd.subeDepoUrunMiktari) depodakitoplamurunmiktarý from subeDepo sd
inner join sube s on s.subeID=sd.subeID
inner join urun u on u.urunID=sd.urunID
group by u.urunAdi ,s.subeID, s.subeAdi
--!!Þubelerin depolarýnda kalan ürün miktarý


--IL ILCE SORGULARI
select il.ilID, il.subeIl,ilce.subeIlce, s.subeAdi,s.subeAdres from sube s
inner join ilTablosu il on il.ilID=s.ilID
inner join ilceTablosu ilce on ilce.ilceID=s.ilceID
--Þubelerin il ve ilçe olarak sistemde gözükmesi

select il.ilID,il.subeIl,ilce.ilceID,ilce.subeIlce  from ilTablosu il 
inner join ilceTablosu ilce on ilce.ilID=il.ilID
--Bütün il ve ilçelerin birbiri ile eþleþmesi