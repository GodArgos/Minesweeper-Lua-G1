-- cd C:\Program Files\LOVE
-- love.exe "ruta main.lua"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------CAMBIAR PATH EN FILE_LOGIC PARA QUE FUNCIONE--------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
require('file_logic')            -- Archivo de lógica enfocada al highscore
suit = require('suit-master')    -- Librearía para elementos del GUI, solo se uso el botón y el input field

local input = {text = ""}
local exp_times = {}
local i = 1

function StartGame()
   local exp_startTime = os.clock()

   function inarray(elem,array)
      for inarr = 1,#array do
         if ( elem[1]== array[inarr][1] and elem[2] == array[inarr][2]) then
            return true
         end
      end
      return false
   end
   
   function inarraysub(elem,array)
      for inarr = 1,#array do
         if ( elem== array[inarr]) then
            return inarr
         end
      end
   end
   
   function buttonclick(x,y,button,pic)
      list = {simple,medium,expert,custom}
      h = inarraysub(pic,list)*50 + 100
      if(button == 1 and x>=76 and x<=76 + pic:getWidth( ) and y>=h and y<=h + pic:getHeight()) then
         return true
      end
      return false
   end
   
   function check(x,y,boom,w,h)
      cal = 0
      if(x>1 and y>1) then
         if(inarray({x-1,y-1},boom)) then cal = cal + 1 end
      end
      if(x>1) then
         if(inarray({x-1,y},boom)) then cal = cal + 1 end
      end
      if(x>1 and y<h) then
         if(inarray({x-1,y+1},boom)) then  cal = cal + 1 end
      end
      if(y>1) then
         if(inarray({x,y-1},boom)) then cal = cal + 1 end
      end
      if(y<h) then
         if(inarray({x,y+1},boom)) then cal = cal + 1 end
      end
      if(x<w and y>1) then
         if(inarray({x+1,y-1},boom)) then cal = cal + 1 end
      end
      if(x<w) then
         if(inarray({x+1,y},boom)) then cal = cal + 1 end
      end
      if(x<w and y<h) then
         if(inarray({x+1,y+1},boom)) then cal = cal + 1 end
      end
      maze[x][y] = cal + 1
      if (cal == 0) then
         if(x>1) then
            if(maze[x-1][y] == 13) then check(x-1,y,boom,w,h) end
         end
         if(x<w) then
            if(maze[x+1][y] == 13) then check(x+1,y,boom,w,h) end
         end
         if(y>1) then
            if(maze[x][y-1] == 13) then check(x,y-1,boom,w,h) end
         end
         if(y<h) then
            if(maze[x][y+1] == 13) then check(x,y+1,boom,w,h) end
         end
         if(x>1 and y>1) then 
            if(maze[x-1][y-1] == 13) then check(x-1,y-1,boom,w,h) end
         end
         if(x>1 and y<h) then
            if(maze[x-1][y+1] == 13) then check(x-1,y+1,boom,w,h) end
         end
         if(x<w and y>1) then
            if(maze[x+1][y-1] == 13) then check(x+1,y-1,boom,w,h) end
         end
         if(x<w and y<h) then
            if(maze[x+1][y+1] == 13) then check(x+1,y+1,boom,w,h) end
         end
      end
   end
   
   function love.textinput(t)
      if #input.text < 3 then -- Se asegura que el nombre del jugador ingresado no pase de 3 caractéres
         suit.textinput(t)
      end
      
   end
   
   function love.keypressed(key)
      suit.keypressed(key)

      if key == 'escape' then
         exp_endTime = os.clock()
         exp_final = exp_endTime - exp_startTime
         local text = string.format("Time: %.2f s", exp_final)
         print(text)
         exp_times[i] = exp_final
         i = i + 1

         text = string.format("Memory: %.2f mbs", collectgarbage("count") / 1000)
         print(text)
         
         love.event.quit("restart")
      end
   end
   
   function love.load() -- Setea constantes y variables al principio de la ejecución del programa
   
      -- Fuentes a usar
      font = love.graphics.newFont(30, 'normal')
      timer_font = love.graphics.newFont(25, 'normal')
      top_font = love.graphics.newFont(20, 'normal')
      high_font = love.graphics.newFont(35, 'normal')
   
      -- Imágenes a usar
      initial = love.graphics.newImage("image/initial.png")
      blank = love.graphics.newImage("image/grid.png")
      flags = love.graphics.newImage("image/flag.png")
      b1 = love.graphics.newImage("image/1.png")
      b2 = love.graphics.newImage("image/2.png")
      b3 = love.graphics.newImage("image/3.png")
      b4 = love.graphics.newImage("image/4.png")
      b5 = love.graphics.newImage("image/5.png")
      b6 = love.graphics.newImage("image/6.png")
      b7 = love.graphics.newImage("image/7.png")
      b8 = love.graphics.newImage("image/8.png")
      bombdisc = love.graphics.newImage("image/bombdisc.png")
      bombboom = love.graphics.newImage("image/bombboom.png")
      won = love.graphics.newImage("image/win.png")
      title = love.graphics.newImage("image/title.png")
   
   
      -- Niveles
      simple = love.graphics.newText(font, "Simple (9*9,10 mines)")
      medium = love.graphics.newText(font,"Medium (16*16,40 mines)")
      expert = love.graphics.newText(font,"Expert (30*16,99 mines)")
   
   
      -- Variables
      start = false
      continue = true
      new = false
      top = false
      cont = 1
      cont_1 = 1
      cont_2 = 1
      name = ""
   
      love.window.setMode(512,512) -- Tamaño de la ventana
      element ={blank,b1,b2,b3,b4,b5,b6,b7,b8,flags,bombdisc,bombboom,initial}
   end
   
   function love.draw() -- Dibuja por cada frame todo lo que se encuentre en la funcion
      if new == false then
         if(start) then
            love.graphics.setColor(255, 255, 255, 255)
            
            if cont == 1 then           -- Toma el tiempo de inicio (tiempo del sistema) una sola vez
               timer_start = os.time()
               show_time_start = os.time()
               cont = cont + 1
            end
            
            love.graphics.setBackgroundColor(0.7,1,1,1)
      
            for i = 1,wide do           -- Dibuja la matriz de celdas
               for j = 1,height do 
                  love.graphics.draw(element[maze[i][j]], 18+32*i, 18+32*j)
               end
            end
   
            -- Muestra el tiempo actual en pantalla
            show_time_final = os.difftime(show_time_end, show_time_start)
            show_seconds = math.floor(((show_time_final) % 60))
            show_minutes = math.floor(((show_time_final) / 60))
   
            timertext = string.format("%02d:%02d", show_minutes, show_seconds)
   
            love.graphics.setColor(0, 0, 0)
            love.graphics.setFont(timer_font)
            love.graphics.print(timertext, 150, 15)
            
            if(win) then
               love.graphics.draw(won,50,32*height+49)  
   
               if cont_2 == 1 then      -- Calcula el tiempo que el jugador se demoró en ganar
                  timer_final = os.difftime(timer_end, timer_start)
                  seconds = math.floor(((timer_final) % 60))
                  minutes = math.floor(((timer_final) / 60))
                  new = true
               end
            end
         else
            -- Dibuja el menú Principal
            love.graphics.draw(title,0,20)
            love.graphics.draw(simple,76,150)
         end
      else
         if(top == false) then -- Dibuja la pantalla para ingresar el nombre del jugador
            love.graphics.setFont(top_font)
            love.graphics.print("INGRESE SU NOMBRE", 90,120)
            love.graphics.setBackgroundColor(0.7,1,1,1)
            suit.draw()
         else
            love.graphics.setFont(high_font)  -- Dibuja la pantalla del TOP 3 de jugadores
            love.graphics.print("- TOP 3 -", 125,80)
            love.graphics.setBackgroundColor(0.7,1,1,1)
            suit.draw()
            
            if cont_2 == 1 then
               HIGHSCORES(name, timer_final) -- Calcula el top 3
               printTop()                    -- Muestra el top 3
            end
         end
         
         
      end
   end
   
   function love.update(dt) -- Funcion que se llama cada frame
      if (new == false and continue == true) then -- Actualiza el tiempo actual, solo si no se ha ganado y el juego sigue funcionando 
         show_time_end = os.time()
      end
   
      if win and cont_1 == 1 then -- Guarda el tiempo final una vez que el jugador gana
         timer_end = os.time()
         cont_1 = cont_1 + 1
      end
   
      if(new) and top == false then -- Muestra el input field si la nueva pantalla se ve
         love.graphics.setFont(top_font)
         suit.Input(input, 100,160,200,30)
         
         state = suit.Button("OK", 255, 200, 45,30)
         
         if state.hit then -- Si el botón se ha presionado
            top = true
            name = input.text
         end
   
      end
   end
   
   function love.mousepressed (x, y, button, istouch)
      if(start) then
         if(continue) then
            gridx = (x-18-(x-18)%32)/32
            gridy = (y-18-(y-18)%32)/32
            if(gridx>=1 and gridx<= wide and gridy>=1 and gridy<=height) then
               if(button == 1) then
                  if(maze[gridx][gridy] == 13) then
                     if(inarray({gridx,gridy},bombxy)) then 
                        continue = false
                        for i = 1, number do
                           if(maze[bombxy[i][1]][bombxy[i][2]] == 10) then
                              maze[bombxy[i][1]][bombxy[i][2]] = 11
                           else
                              maze[bombxy[i][1]][bombxy[i][2]] = 12
                           end
                        end
                     else
                        check(gridx,gridy,bombxy,wide,height) 
                     end
                  end
               end
               if(button == 2) then
                  if(maze[gridx][gridy] == 13) then
                     maze[gridx][gridy] = 10
                  elseif(maze[gridx][gridy] == 10) then
                     maze[gridx][gridy] = 13
                  end
               end
            end
            if(continue) then
               win = true
               for i = 1, wide do
                  for j = 1, height do
                     if (maze[i][j] == 13) then
                        win = false
                     end
                  end
               end
               if(win) then 
                  continue = false
               end 
            end
         end
      else
         if(buttonclick(x,y,button,simple)) then
            validclick = true
            wide = 9
            height = 9
            number = 10
         end
         if(validclick) then
            love.window.updateMode(32*wide+100,32*height+100)
            maze ={}
            for i = 1,wide do
               maze[i] = {}
            end
            for i = 1,wide do
               for j = 1,height do
                  maze[i][j] = 13
               end
            end
            bombxy ={}
            bombxy[1] = {love.math.random( 1, wide ),love.math.random( 1, height )}
            for k = 2,number do
               temp = {love.math.random( 1, wide ),love.math.random( 1, height )}
               while (inarray(temp,bombxy)) do
                  temp = {love.math.random( 1, wide ),love.math.random( 1, height )}
               end
               bombxy[k] = temp
            end
            start = true
         end
      end
   end
end

StartGame()