
insert into sube (subeID, subeAdi, ilID,ilceID,subeAdres,subeTelefon)
values ('6','Sube6','1','2','At�k Caddesi','02127641789')
--yeni a��lan �ube sisteme kay�t edilir.


insert into personel (personelID,personelAd,personelSoyad,personelTCNo,personelDogumYili,personelTelefon,personelIkametgah,subeID,personelYetkileriID,gorevID) 
values ('22','Mehmet','Kanmaz','27279467289','1985','05394527846','Ba�ak�ehir','6','3','3')
--yeni a��lan �ubeye yeni bir genel m�d�r al�m� yap�l�r ve sisteme kay�t edilir.

  
update personel set subeID=6 where personelID=13
--2.�ubede olan Ebru �etin tecr�beli oldu�undan M�d�r yard�mc�s� olarak 6.�ubeye transfer olmu�tur ve sisteme kay�t edilir.


insert into personel (personelID,personelAd,personelSoyad,personelTCNo,personelDogumYili,personelTelefon,personelIkametgah,subeID,personelYetkileriID,gorevID) 
values ('27','Esma','Sonar','27125467289','1996','05394593421','Davutpa�a','6','5','5')

insert into personel (personelID,personelAd,personelSoyad,personelTCNo,personelDogumYili,personelTelefon,personelIkametgah,subeID,personelYetkileriID,gorevID) 
values ('28','Alihan','Yener','27298457289','1997','05326749835','Bah�elievler','6','5','5')

insert into personel (personelID,personelAd,personelSoyad,personelTCNo,personelDogumYili,personelTelefon,personelIkametgah,subeID,personelYetkileriID,gorevID) 
values ('29','Ay�enur','Konak','27279469834','2000','05319853672','Esenler','6','5','5')
--A��lan yeni �ubeye yeni personel al�m� ve sistemde g�rev yetkilendirilmesi

--PERSONEL G�REV YETK� SORGULARI
select p.personelAd,p.personelSoyad, g.gorevAdi,gy.Yetkiler from personelYetkileri py
inner join personel p on p.gorevID=py.gorevID
inner join gorev g on g.gorevID=py.gorevID
inner join gorevYetki gy on gy.gorevYetkileriID= py.gorevYetkileriID order by personelAd,personelSoyad
--Her personelin sistemdeki g�rev adlar� ve yetkileri


insert into coksatis (satisID,urunID,personelID,satisFiyati,satisMiktari,subeID,satisTutari,satisTarihi) 
values ('54','1','29','20','5','6','100','06-06-2020')
--�ubelerin �r�n bazl� sat�� rakamlar�n�n sisteme aktar�lmas� sorgusu


insert into personelHedef (personelHedefID, personelID, subeID, personelHedef)
values ('18','29','6','3000')
--Personel sat�� hedefinin girilmesi sorgusu


update personelHedef set personelHedef=2000 where personelID=27
--Personel sat�� hedefinin sistemde d�zeltilmesi


--PERSONEL SATI� SORGULARI
select  p.subeID, p.personelAd, p.personelSoyad,s.satisMiktari ,s.satisFiyati,s.satisTarihi from  personel p 
inner join coksatis s on p.personelID=s.personelID order by satisTarihi
--Tarih bazl� personellerin sat�� miktar� ve birim sat�� fiyat�

select cs.satisTarihi,  sum(cs.satisTutari) g�nl�ksatis  from coksatis cs group by satisTarihi
--Her g�n yap�lan sat�� toplam�

select p.personelID,p.personelAd,p.personelSoyad, sum(s.satisTutari) satisTutari, ph.personelHedef from coksatis s 
inner join personelHedef ph on s.personelID=ph.personelID
inner join personel p on s.personelID=p.personelID
group by ph.personelHedef,p.personelID,p.personelAd,p.personelSoyad
--Her bir personelin hedefi ve sat��lar�

select p.personelID,p.personelAd,p.personelSoyad,ph.personelHedef, sum(s.satisTutari) toplamsatis from personel p
inner join personelHedef ph on ph.personelID=p.personelID 
inner join coksatis s on s.personelID= p.personelID
group by p.personelID,ph.personelHedef,p.personelAd,p.personelSoyad
having ph.personelHedef< sum(s.satisTutari)
--!!Personel belirlenen hedefe ula�t� m�?
--Ba�ar�l� personellerin belirlenmesi


select p.personelAd,p.personelSoyad, s.subeAdi, il.subeIl  ,ilce.subeIlce,sum(cs.satisTutari) satisTutari from sube s
inner join personel p on s.subeID=p.subeID
inner join ilceTablosu ilce on ilce.ilceID=s.ilceID
inner join ilTablosu il on il.ilID=s.ilID
inner join coksatis cs on cs.personelID=p.personelID
group by personelAd,personelSoyad,s.subeAdi, il.subeIl  ,ilce.subeIlce
--her bir personelin sat���n� subeleri ve il�eleriyle beraber g�r�lmesi


select s.subeID,s.subeAdi, il.subeIl  ,ilce.subeIlce,sh.subeHedef,sum(cs.satisTutari) subesatis from sube s
inner join personel p on s.subeID=p.subeID
inner join ilceTablosu ilce on ilce.ilceID=s.ilceID
inner join ilTablosu il on il.ilID=s.ilID
inner join coksatis cs on cs.personelID=p.personelID
inner join subeHedef sh on sh.subeID=s.subeID
group by s.subeID,s.subeAdi, il.subeIl  ,ilce.subeIlce,sh.subeHedef
--!!�ube il ve il�eleriyle belirlenen hedefe ula�t� m�?


--SEVK�YAT SORGULARI
select u.urunAdi,se.siparisDurumu ,se.sevkiyatTeslimTarihi  from urun u
inner join subeDepo sd on sd.urunID= u.urunID
inner join anaDepo a on a.urunID=u.urunID
inner join sevkiyat se on se.urunID=u.urunID where se.siparisDurumu='Haz�rlan�yor'
--!!�r�nlerin tarihlere g�re sipari� durumu


select  s.subeAdi, u.urunAdi,sum(sd.subeDepoUrunMiktari) depodakitoplamurunmiktar� from subeDepo sd
inner join sube s on s.subeID=sd.subeID
inner join urun u on u.urunID=sd.urunID
group by u.urunAdi ,s.subeID, s.subeAdi
--!!�ubelerin depolar�nda kalan �r�n miktar�


--IL ILCE SORGULARI
select il.ilID, il.subeIl,ilce.subeIlce, s.subeAdi,s.subeAdres from sube s
inner join ilTablosu il on il.ilID=s.ilID
inner join ilceTablosu ilce on ilce.ilceID=s.ilceID
--�ubelerin il ve il�e olarak sistemde g�z�kmesi

select il.ilID,il.subeIl,ilce.ilceID,ilce.subeIlce  from ilTablosu il 
inner join ilceTablosu ilce on ilce.ilID=il.ilID
--B�t�n il ve il�elerin birbiri ile e�le�mesi