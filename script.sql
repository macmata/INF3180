select noArticle, description                                                                                                                           
from article                                                                                                                                            
where noArticle BETWEEN 20 AND 80 AND (prixUnitaire = 10.99 OR prixUnitaire = 25.99);   


no 3
select noArticle, description                                           
from article  where description like 'C%' or description like '%bl%';    

no 4
select noClient, nomClient from client natural join commande where dateCommande = '09-07-2000'                                                                                                                      
no 5 
 select nomclient, nocommande, datecommande, noarticle                                                                                                   
 from client natural join commande natural join  lignecommande natural join detaillivraison natural join livraison                                       
 where quantitelivree >1 and datelivraison = '04-06-2000'
no 6                                                                                                
select dateevenem                                                                                                                                       
from (
select datecommande dateevenem from commande where datecommande  between '01-06-2000'and '30-06-2000'
union
select datelivraison dateevenem from livraison where datelivraison between '01-06-2000'and '30-06-2000'
)

no 7 pas terminer
select noarticle,nvl(sum(quantitelivree),0)  from article natural left outer join detaillivraison  group by noarticle order by noarticle                                                                                                                             

no 8
   select noarticle, quantitelivree                                                                                                                        
   from (select noarticle,nvl( sum(quantitelivree),0)as quantitelivree from article natural left join detaillivraison where prixunitaire <20 group by noarticle )      where quantitelivree <5 or quantitelivree is null                                                                                                       
no 9
select nolivraison, nocommande, noarticle, datecommande, quantite, datelivraison,quantitelivree, (datelivraison-datecommande) jours_ecoule              
from commande natural join lignecommande natural join detaillivraison natural join livraison natural join livraison                                     
where  (datelivraison - datecommande > 2 )                                                                                                              
order by nolivraison                                                                                                                                                       

no 10

select noarticle , description, prixunitaire, quantiteenstock                                                                                           
from (select noarticle ,description,prixunitaire,quantiteenstock from article order by noarticle asc)                                                   
order by prixunitaire desc, noarticle asc

no 11
select nombreplusque25 ,nombremoinsque15                                                                                                                
from (select count(noarticle) nombreplusque25 from article where prixunitaire >25 ), (select count( noarticle) nombremoinsque15 from article where prixunitaire <15)


no 12 
select nocommande                                                                                                                                       
from commande natural left outer join detaillivraison                                                                                                        where nolivraison is null                                                                                                                                                     

no 13
version de mathieux
          
