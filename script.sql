spool request.out
set echo on ;
alter session set nls_date_format = 'dd/mm/yyyy';
/* no 2*/
select noArticle, description                                                                                                                           
from article                                                                                                                                            
where noArticle BETWEEN 20 AND 80 AND (prixUnitaire = 10.99 OR prixUnitaire = 25.99);   


/* no 3*/
select noArticle, description                                           
from article  where description like 'C%' or description like '%bl%';    

/* no 4*/
select noClient, nomClient from client natural join commande where dateCommande = '09-07-2000';                                                              

/* no 5*/
select nomclient, nocommande, datecommande, noarticle                                                                                                   
from client natural join commande natural join  lignecommande natural join detaillivraison natural join livraison                                       
where quantitelivree >1 and datelivraison = '04-06-2000';                                          

/* no 6*/
select dateevenem                                                                                                                                       
from (
select datecommande dateevenem from commande where datecommande  between '01-06-2000'and '30-06-2000'
union
select datelivraison dateevenem from livraison where datelivraison between '01-06-2000'and '30-06-2000'
);

/* no 7*/
select noarticle,nvl(sum(quantitelivree),0) quantitelivree   from article natural left outer join detaillivraison  group by noarticle order by noarticle;                                                                                                                             

/* no 8*/
select noarticle, quantitelivree                                                                                                                        
from (select noarticle,nvl( sum(quantitelivree),0) quantitelivree from article natural left join detaillivraison where prixunitaire <20 group by noarticle )      where quantitelivree <5 or quantitelivree is null;

/* no 9*/
select nolivraison, nocommande, noarticle, datecommande, quantite, datelivraison,quantitelivree, (datelivraison-datecommande)nombrejoursecoule
from commande natural join lignecommande natural join detaillivraison natural join livraison natural join livraison                                     
where  (datelivraison - datecommande > 2 )                                                                                                              
order by nolivraison;                                                                                                                                        

/* no 10*/
select noarticle , description, prixunitaire, quantiteenstock                                                                                           
from (select noarticle ,description,prixunitaire,quantiteenstock from article order by noarticle asc)                                                   
order by prixunitaire desc, noarticle asc;

/* no 11*/
select nombrepluscherque25,nombremoischerque15
from (select count(noarticle)nombrepluscherque25 from article where prixunitaire >25), (select count( noarticle)nombremoischerque15 from article where prixunitaire <15);

/* no 12*/
select nocommande                                                                                                                                       
from commande natural left outer join detaillivraison                                                                                                        where nolivraison is null;


spool off 
          
