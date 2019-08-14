using Cascadia
using DataFrames
using Gumbo
using HTTP
using AbstractTrees

baseUrl = "https://www.dofus.com/en/mmorpg/encyclopedia/equipment?page="

maxpages = 97

fullLinks = []

function getDetailUrls(url)
    res = HTTP.get(url);
    body = String(res.body)
    links = []

    #First half
    beginstring = """<tr class="ak-bg-even">\n<td><span class="ak-linker"><a href="""
    endstring = "><img"

    beginIndexes = findnext(beginstring, body, 1)

    while !isnothing(beginIndexes)
        beginIndex = beginIndexes[end] + 2
        endIndexes = findnext(endstring, body, beginIndex)
        endIndex = endIndexes[1] -2
        beginIndexes = findnext(beginstring, body, endIndex)

        push!(links,body[beginIndex:endIndex])
    end

    #Second half
    beginstring = """<tr class="ak-bg-odd">\n<td><span class="ak-linker"><a href="""

    beginIndexes = findnext(beginstring, body, 1)

    while !isnothing(beginIndexes)
        beginIndex = beginIndexes[end] + 2
        endIndexes = findnext(endstring, body, beginIndex)
        endIndex = endIndexes[1] -2
        beginIndexes = findnext(beginstring, body, endIndex)

        push!(links,body[beginIndex:endIndex])
    end

    return links
end

for i = 1:1
    global fullLinks
    fullLinks = [fullLinks; getDetailUrls(string(baseUrl , "$i"))]
    println(fullLinks)
end
