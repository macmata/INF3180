spool requetes.out

set echo on
/

alter session set nls_date_format = 'dd/mm/yyyy'
/

-- 1.   Les numéros des clients (sans répétition) qui ont placé au moins une commande

select distinct client.noclient
  from client, commande
  where client.noclient = commande.noclient
/

-- 2.   Le numéro et la description des articles dont le numéro est entre 20 et 80 (inclusivement) et le prix est 10.99 ou 25.99

select noArticle, description
from article
where noArticle BETWEEN 20 AND 80 AND (prixUnitaire = 10.99 OR prixUnitaire = 25.99)
/

-- 3.   Le numéro et la description des articles dont la description débute par la lettre C ou contient la chaîne 'bl'

select noArticle, description
from article  where description like 'C%' or description like '%bl%'
/

-- 4.   Le numéro et le nom des clients qui ont placé une commande le 9 juillet 2000

select noClient, nomClient from client natural join commande where dateCommande = '09-07-2000'
/

-- 5.   Les noms des clients, numéros de commande, date de commande et noArticle pour les articles livrés le 4 juin 2000 dont la quantité livrée est supérieure à 1

select nomclient, nocommande, datecommande, noarticle
from client natural join commande natural join  lignecommande natural join detaillivraison natural join livraison
where quantitelivree >1 and datelivraison = '04-06-2000'
/

-- 6.   La liste des dates du mois de juin 2000 pour lesquelles il y a au moins une livraison ou une commande. Les résultats sont produits en une colonne nommée DateÉvénement.

select dateevenem as DateEvenement
from (
select datecommande dateevenem from commande where datecommande  between '01-06-2000'and '30-06-2000'
union
select datelivraison dateevenem from livraison where datelivraison between '01-06-2000'and '30-06-2000'
)
/

-- 7.   Les noArticle et la quantité totale livrée de l’article incluant les articles dont la quantité totale livrée est égale à 0.

select noarticle, nvl(sum(quantitelivree),0) quantitelivree
from article natural left outer join detaillivraison
group by noarticle
order by noarticle
/

-- 8.   Les noArticle et la quantité totale livrée de l’article pour les articles dont le prix est inférieur à $20 et dont la quantité totale livrée est inférieure à 5

select noarticle, quantitelivree
from (
select noarticle, nvl(sum(quantitelivree),0) quantitelivree
from article natural left join detaillivraison
where prixunitaire <20 group by noarticle
)
where quantitelivree <5 or quantitelivree is null
/

-- 9.   Le noLivraison, noCommande, noArticle, la date de la commande, la quantité commandée, la date de la livraison, la quantitée livrée et le nombre de jours écoulés entre la commande et la livraison dans le cas où ce nombre a dépassé 2 jours et le nombre de jours écoulés depuis la commande jusqu’à aujourhd’hui est supérieur à 100

select nolivraison, nocommande, noarticle, datecommande, quantite, datelivraison,quantitelivree, (datelivraison-datecommande) nombrejoursecoule
from commande natural join lignecommande natural join detaillivraison natural join livraison natural join livraison
where ( datelivraison - datecommande > 2 )
order by nolivraison
/

-- 10.  La liste des Articles triée en ordre décroissant de prix et pour chacun des prix en ordre croissant de numéro

select *
from article
order by prixunitaire desc, noarticle asc
/

-- 11.  Le nombre d’articles dont le prix est supérieur à 25 et le nombre d'articles dont le prix est inférieur à 15 (en deux colonnes)

select nombrepluscherque25,nombremoischerque15
from (select count(noarticle)nombrepluscherque25 from article where prixunitaire >25), (select count( noarticle)nombremoischerque15 from article where prixunitaire <15)
/

-- 12.  Les noCommande des commandes qui n'ont aucune livraison correspondante

select nocommande
from commande natural left outer join detaillivraison
where nolivraison is null
/

-- 13.  En deux colonnes, les paires de numéros de commandes (différentes) qui sont faites à la même date ainsi que la date de commande. Il faut éviter de répéter deux fois la même paire.

select distinct least(c1.nocommande, c2.nocommande) as nocommande, greatest(c1.nocommande, c2.nocommande) as nocommande, c1.datecommande
  from commande c1, commande c2
  where   c1.nocommande <> c2.nocommande
    and c1.datecommande = c2.datecommande
/

-- 14.  Le montant total commandé pour chaque paire (dateCommande, noArticle) dans les cas où le montant total dépasse 50$.

select commande.datecommande, lignecommande.noarticle, sum(article.prixunitaire * lignecommande.quantite) as "Montant total commande"
  from commande, lignecommande, article
  where commande.nocommande = lignecommande.nocommande and
    lignecommande.noarticle = article.noarticle
  group by commande.datecommande, lignecommande.noarticle
  having sum(article.prixunitaire * lignecommande.quantite) > 50
/

-- 15.  Les noArticle des articles commandés dans toutes et chacune des commandes du client 20

select t.article as NOARTICLE
  from
    (select lignecommande.noarticle as article, count(*) as total
     from commande, lignecommande
     where commande.nocommande = lignecommande.nocommande
       and commande.noclient = 20
     group by lignecommande.noarticle) t
  where t.total = (
    select count(distinct lignecommande.nocommande)
      from commande, lignecommande
      where commande.nocommande = lignecommande.nocommande
        and commande.noclient = 20)
/


spool off 
          
