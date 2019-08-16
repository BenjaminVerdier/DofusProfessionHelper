using Cascadia
using DataFrames
using Gumbo
using HTTP
using AbstractTrees
using SQLite

function getDetailPages(url)
    links = []
    res = HTTP.get(url);
    body = String(res.body)
    html = parsehtml(body);

    #print(html.root.body)

    qres = eachmatch(sel".ak-bg-odd", html.root)

    for elem in qres
        push!(links, getattr(elem[1][1][1], "href"))
    end

    qres = eachmatch(sel".ak-bg-even", html.root)

    for elem in qres
        push!(links, getattr(elem[1][1][1], "href"))
    end
    return links
end

function getItemDetails(url)
    completeUrl = string("https://www.dofus.com", url)
    res = HTTP.get(completeUrl);
    body = String(res.body)
    html = parsehtml(body);
    name = ""
    type = ""
    level = 0
    recipe = ""
    id = 0 #from url
    #id
    id = parse(Int,url[findlast(isequal('/'), url) + 1 : findfirst(isequal('-'), url) - 1])
    #name
    qres = eachmatch(sel"h1", html.root)
    for e in qres
        name = e[2].text[2:end-1]
    end
    #type
    qres = eachmatch(sel".ak-encyclo-detail-type", html.root)
    for e in qres
        type = e[3][1]
    end
    #level
    qres = eachmatch(sel".ak-encyclo-detail-level", html.root)
    for e in qres
        level = parse(Int,e[1].text[8:end])
    end
    #Recipe
    craftElements = eachmatch(sel".ak-crafts", html.root)
    if length(craftElements) == 0
        return []
    end
    qres = eachmatch(sel".ak-list-element", craftElements[1])
    for e in qres
        qty = parse(Int,e[1][1].text[1:end-2])
        resource = e[2][1][2][1][1][1][1].text
        recipe = string(recipe, resource, ":", qty, ",")
    end
    recipe = recipe[1:end-1]
    return [id, name, level, type, recipe]
end


function insertToDB(listOfObjects)
    db = SQLite.DB("../db/dofus.db")
    for object in listOfObjects
        truc = string("INSERT INTO equipmentsEN VALUES (", object[1], ",\"", object[2], "\",", object[3], ",\"", object[4], "\",\"",  object[5], "\");")
        SQLite.Query(db, truc)
    end
end

function populateLinks()
    links = []
    #Equipments
    baseUrl = "https://www.dofus.com/en/mmorpg/encyclopedia/equipment?size=96&page="
    numberOfPages = 25
    for i = 1:numberOfPages
        links = [links;getDetailPages(string(baseUrl, "$i"))]
    end

    #Weapons
    baseUrl = "https://www.dofus.com/en/mmorpg/encyclopedia/weapons?size=96&page="
    numberOfPages = 8
    for i = 1:numberOfPages
        push!(links,getDetailPages(string(baseUrl, "$i")))
    end

    #Now we have links thats full of links

    file = open("links.txt","w")

    for url in links
        write(file,string(url, "\n"))
    end

    close(file)

    return links
end

urls = []
open("links.txt") do file
    for ln in eachline(file)
        push!(urls, ln)
    end
end

if length(urls) == 0
    urls = populateLinks()
else
    println(length(urls))
end


i = 1
open("lastVisited.txt") do file
    i =  parse(Int,readline(file))
end


objects = []
for url in urls
    global objects
    global i
    try
        obj = getItemDetails(url)
        if length(obj) > 0
            push!(objects, obj)
        end
        i+=1
        if i % 10 == 0
            println("Done with $i")
        end
    catch
        file = open("lastVisited.txt","w")
        write(file,string(i))
        close(file)
        println("reached limit")
        break
    end
end

insertToDB(objects)
