local path = "C:\\Users\\joaqu\\Documents\\GitHub\\Minesweeper-Lua-G1\\highscores.txt" -- Carpeta destino del txt que contiene el highscore
                                                                                       -- Agregar "\\"" entre cada carpeta

highscores = {}
aux = 0
token = 0

function partition(array, left, right, pivotIndex)
    -- Para ordenar por el score del jugador, se añade a todo .playerscore y .playername.
    -- Esto cambia tanto el score como el nombre, de lugares cuando sea necesario su orden.
	local pivotValue = array[pivotIndex].playerscore
	array[pivotIndex].playerscore, array[right].playerscore, array[pivotIndex].playername, array[right].playername = array[right].playerscore, array[pivotIndex].playerscore, array[right].playername, array[pivotIndex].playername
	
	local storeIndex = left
	
	for i = left, right-1 do
    	if array[i].playerscore <= pivotValue then
	        array[i].playerscore, array[storeIndex].playerscore, array[i].playername, array[storeIndex].playername = array[storeIndex].playerscore, array[i].playerscore, array[storeIndex].playername, array[i].playername
	        storeIndex = storeIndex + 1
		end
		array[storeIndex].playerscore, array[right].playerscore, array[storeIndex].playername, array[right].playername = array[right].playerscore, array[storeIndex].playerscore, array[right].playername, array[storeIndex].playername
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
    if token == 0 then
        for i = 1, #highscores do -- Si solo hay un jugador
            local seconds = math.floor(((highscores[i].playerscore) % 60)) -- Calcula los segundos
            local minutes = math.floor(((highscores[i].playerscore) / 60)) -- Calcula los minutos
            local _text = string.format("%02d:%02d", minutes, seconds)
            love.graphics.print(i..". "..highscores[i].playername.." - ".._text, font, 90, 120+30*i)
        end
    else
        for i = 1, (#highscores - 1) do -- Si hay más de un jugador
            local seconds = math.floor(((highscores[i].playerscore) % 60)) -- Calcula los segundos
            local minutes = math.floor(((highscores[i].playerscore) / 60)) -- Calcula los minutos
            local _text = string.format("%02d:%02d", minutes, seconds)
            love.graphics.print(i..". "..highscores[i].playername.." - ".._text, font, 90, 120+30*i)
        end
    end
    
end

function fileToArray(name, score)
   file = io.open(path, "r")
 
   local i = 1
   for line in file:lines() do
    _name, _score = line:match("^(.-),(%d+)")
    table.insert(highscores, {playerscore = tonumber(_score), playername = _name}) -- Guarda jugadores antiguos del top en el array/table
    i = i + 1
   end
   file:close()
   
   table.insert(highscores, {playerscore = tonumber(score), playername = name}) -- Guarda al jugador actual en el array/table
   quicksort(highscores, 1, #highscores) -- Realzia un quicksort para ordenar de menor a mayor
   token = 1
end

function writeFile(name, total) -- Para un solo jugador
    file = io.open(path, "w")
    local text = string.format("%s,%d", name, total)
    file:write(text, "\n")
    file:close()

    table.insert(highscores, {playerscore = total, playername = name}) -- Guarda al jugador en el array/table
end

function saveToFile() -- Para más de un jugador
    file = io.open(path, "w")
    file:write("") -- Limpia el archivo
    file:close()

    file = io.open(path, "a")
    for i = 1, (#highscores - 1) do
        local text = string.format("%s,%d", highscores[i].playername, highscores[i].playerscore)
        file:write(text, "\n") -- Agrega el nombre del jugador y su tiempo por línea
    end
    file:close()
end

function HIGHSCORES(name, total)
    if aux == 0 then -- Solo debe calcularse una vez
        local file_exists = io.open(path, "r") ~= nil -- Chequea que el archivo existe

        if(file_exists) then               -- Existe
            fileToArray(name, total)
            saveToFile()
        else                               -- No existe
            writeFile(name, total)
        end

        aux = aux + 1;
    end
end