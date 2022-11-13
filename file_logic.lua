local path = "C:\\Users\\joaqu\\Documents\\GitHub\\Minesweeper-Lua-G1\\highscores.txt"

highscores = {}
aux = 0

function partition(array, left, right, pivotIndex)
    -- Para ordenar por el score del jugador, se añade a todo .playerscore
	local pivotValue = array[pivotIndex].playerscore
	array[pivotIndex].playerscore, array[right].playerscore = array[right].playerscore, array[pivotIndex].playerscore
	
	local storeIndex = left
	
	for i = left, right-1 do
    	if array[i].playerscore <= pivotValue then
	        array[i].playerscore, array[storeIndex].playerscore = array[storeIndex].playerscore, array[i].playerscore
	        storeIndex = storeIndex + 1
		end
		array[storeIndex].playerscore, array[right].playerscore = array[right].playerscore, array[storeIndex].playerscore
	end
	
   return storeIndex
end

function quicksort(array, left, right)
	if right > left then
	    local pivotNewIndex = partition(array, left, right, right) -- En lugar de left como último parámetro, se puso right para que se en orden ascendente
	    quicksort(array, left, pivotNewIndex - 1)
	    quicksort(array, pivotNewIndex + 1, right)
	end
end

function printTop()
    for i = 1, #highscores do
        print(i..".Player: "..highscores[i].playername.." Time: "..highscores[i].playerscore)
    end
end

function fileToArray(minutes, seconds)
   file = io.open(path, "r")
 
   local i = 1
   for line in file:lines() do
    name, score = line:match("^(.-),(%d+)")
    table.insert(highscores, {playerscore = score, playername = name})
    i = i + 1
   end

   quicksort(highscores, 1, #highscores)
   printTop()
end

function writeFile(minutes, seconds)
    file = io.open(path, "w")
    local score = string.format("%02d:%02d", minutes, seconds)
    --print(score)
    file:write(score)
    file:close()
end

function HIGHSCORES(minutes, seconds)
    if aux == 0 then
        local file_exists = io.open(path, "r") ~= nil

        if(file_exists) then
            fileToArray(minutes, seconds)
        else
            writeFile(minutes, seconds)
        end
        aux = aux + 1;
    end
end