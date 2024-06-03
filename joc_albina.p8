pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
x = 90
y = 56
x_g = 0
y_g = 0
hp = 3
score = 0
end_time = 0
set_time = true
death_time = -1
function _init()
	t,f,s=0,1,7
	sp_lr={33,35}
	sp_ud={40,43}
	sp_d=37
	sp_g={45,77}
	sp_e={81,86}
	sp_h={19,20}
	enemies_table={}
	music(00)
end

function _update()
	t= (t+1)%s
	if (t==0) f=f%#sp_lr+1
	
	if hp==0 then
	return
	end
	
	if(btn(⬆️) and y >= 8) then
	y-=3
	flip_ud = false
	move_lr = false
	end
	
	if(btn(⬇️) and y <= 110) then
	 y+=3
	 flip_ud = true
	 move_lr = false
	 end
	if(btn(⬅️) and x >= 8) then
	 x-=3
	 flip_lr = true
	 move_lr = true
	 end
	if(btn(➡️) and x <= 190) then
	x+=3
	flip_lr = false
	move_lr = true
	end
	if(btn(❎)) then
		if start_time < 0 then
		start_time = 0
		end
	end_time = time()+2
	sfx(00)
	collide_e()
	end
end

function _draw()
	cls(14)
	
	if death_time > 0 and time() > death_time then
		stop("game over!", 48, 64)
	end
	
	current_time = time()
	
	camera_follow()
	collide_h()
	
	palt(0,false)
	palt(11, true)
	map(0,0,0,0,32,32)
	
	draw_hp()
	draw_score()
	draw_enemies()
	enemy_ai()
	
	if hp==0 then
	if set_time then
		death_time = time() + 2
		set_time=false
	end
	spr(sp_d,x,y,2,2,false,false)
	return
	end
	
	if current_time%5==0 then
		create_enemy()
	end
	
	
	if move_lr then
	spr(sp_lr[f],x,y,2,2,flip_lr,false)
	else
	spr(sp_ud[f],x,y,2,2,false,flip_ud)
	end
	if current_time <= end_time then
	spr(sp_g[f],x,y,2,2,false,false)
	animate_g()
	collide_e()
	else
		start_time = -1
		--end of glitter
	end
end

--function _innit

--function _pollinisation
--when the character stayes long enough whthin the reach 
--of a flower
--it is a timed action

--function _gain points
--points are gained through pollinisation

--function _damage
--damage is received by colliding into enemies

--function _items
--random flowers that need to be pollinisation
--need to appear ranadomly in order to be able
--to receive points

--function _fly
--the character needs to move around the map
--in all directions

--function _speed
-- setting up the speed
--it can also be increased when collecting special items

--function _background
--setting the background
--it should also shake when the character receives damage

--function _death
--it the player receives damage 3 times the game is over

--function _update

--function _draw
-->8
function animate_g()
	start_time = start_time+1
	r = min(start_time,20)
	for  i=0,20 do
		a = rnd(360)
		x_g = sin(a)*r
		y_g = cos(a)*r
		if rnd(100) < 15 then
		pset(x+x_g+7,y+y_g+8,8)
		pset(x+x_g+9,y+y_g+8,8)
		pset(x+x_g+8,y+y_g+9,8)
		pset(x+x_g+8,y+y_g+7,8)
		else
			pset(x+x_g+8,y+y_g+8,8)
		end
	end
end

function draw_hp()

if hp>=1 then 
spr(sp_h[1],cam_x+10,cam_y+10,1,1,false,false)
else
spr(sp_h[2],cam_x+10,cam_y+10,1,1,false,false)
end

if hp>=2 then
spr(sp_h[1],cam_x+20,cam_y+10,1,1,false,false)
else
spr(sp_h[2],cam_x+20,cam_y+10,1,1,false,false)
end

if hp==3 then
spr(sp_h[1],cam_x+30,cam_y+10,1,1,false,false)
else
spr(sp_h[2],cam_x+30,cam_y+10,1,1,false,false)
end
end

function draw_score()
	print("score: "..score,cam_x+90,cam_y+10,0)
end	
-->8
function camera_follow()
cam_x = x - 56
cam_y = y - 56

cam_x = mid(0, cam_x, 88)
cam_y = mid(0, cam_y, 8)

camera(cam_x, cam_y)
end
-->8
function draw_enemies()
for v in all(enemies_table) do
	if v[4] then
	spr(v[1]+2,v[2],v[3],2,2,false,false)
	else
	spr(v[1],v[2],v[3],2,2,false,false)
	end
end
end

function create_enemy()
	add(enemies_table, {rnd(sp_e),
		flr(rnd(200)),
		flr(rnd(100)),
		false})
end

function collide_h()
	for v in all(enemies_table) do
		if abs(x+2 - v[2]) <= 10 then
		if abs(y+2 - v[3]) <= 10 then
		if v[4] == false then
		hp=hp-1
		del(enemies_table, v)
		end
		end
		end
	end
end

function collide_e()
	for v in all(enemies_table) do
	 if abs(x+x_g+8 - v[2]) < 10 then
	 if abs(y+y_g+8 - v[3]) < 10 then
	 if v[4]==false then
	 v[4] = true
	 score=score+1
	 end
	 end
	 end
	end
end
-->8
function enemy_ai()

for v in all(enemies_table) do
	if v[4] == false then
		if v[2]<x then
		v[2] = v[2]+1
		else 
		v[2] = v[2]-1
		end
		
		if v[3]<y then
		v[3] = v[3]+1
		else 
		v[3] = v[3]-1
		end
	end
end

end
__gfx__
00000000777777777777777767776776767777766666666666666666666666667777777777777777777777777777777777777777777777777767766676777666
00000000777777777777777776767677777676776666666666666666666666667776777777777757777777677677777776777777777777776777666677776666
00700700777777777777767777777766767777676666666676666667766666677768677777677777776777777767776777777777777777777776666677766666
00077000777777777677677767666677676666766666666667666676776666777776577776767777768677777767767777777777777777777676666676766666
00077000777777777767677776666667766666676666666677767777677767677777757577677677776778777767777777776777777767777776666677766666
00700700777777777767776766666666666666666666666676777677776776767787755767776567777785877777776777767777777777777766666667766666
00000000777777777777777766666666666666666666666677777776777777777878557777777677767778777777677777777777777777777777666677676666
00000000777777777777777766666666666666666666666677767777777677677787777777677777777677777777777777777777777777777776766667777666
000000006667776766677677b00b00bbb00b00bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000066667777666677770880870b0550560b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000066666776666667770888880b0555550b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000066666767666667670888880b0555550b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006666677766666777b08880bbb05550bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006666677666666777bb080bbbbb050bbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006666777766667677bbb0bbbbbbb0bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006667777666676776bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbb0000bbbbbbbbbbbbbb0000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbb8bbbbbbb00
00000000bbbb06600bbbbbbbbbbbb00660bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000bbbbbbbbbbbbbbbbb0000000bbbbb8bbbbbbbbbbbbbbbbbbbb00
00000000b00006560bbbbbbbb000006650bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb077777770bbbbbbbbbbbbbbb077777770bbb8b8bbbbbbbbbbb8bbbbbbb00
00000000b06606650bbbbbbb0066006560bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb07707770770bbbbbbbbbbbbb07707770770bbb8bbbbbbbbbbbbbbbbbbbb00
00000000b06560660000bbbb065560560000bbbbbbbb00000000bbbbbbbbbbbbb005577777775500bbbbbbbbbb0057777777550bbbbbbbbbbbbbbbbbbbbbbb00
00000000b066565577550bbb0066565577550bbbbbb0755577550bbbbbbbbbbbb060555555555060bbbbbbbbbb0555555555550bbbbbbbbbbbbbbbbbbbbbbb00
00000000bb066557755570bbb0066557755570bbbb077557755560bbbbbbbbbbb060055555550060bbbbbbbbb0005555555550008bbbbbbbbbbbbbb8bbbbbb00
00000000bb0555577557770bbb0555577557770bb0777557755760bbbbbbbbbbb056077777770650bbbbbbbbb056077777770560bbbbbbbbbbbbbbbbbbbbbb00
00000000bb0565577557070bbb0565577557070bb0777557755760bbbbbbbbbbb000066666660000bbbbbbbbb066066666660660bbbbbbbbbbbbbbbbbbbbbb00
00000000b00565577557070b000565577557070bb00705577557600bbbbbbbbbbb0555555555550bbbbbbbbbb056055555550560bbbbbbbbbbbbbb8bbbbbbb00
00000000000565577557770bb00565577557770bb070755775576000bbbbbbbbbbb05555555550bbbbbbbbbbb000055555550000bbbbbbbbbbbbbbbbbbbbbb00
00000000bb0565577557700bbb0565577557700bb0070557755760bbbbbbbbbbbbbb066666660bbbbbbbbbbbbbbb066666660bbbbbbbbbbbbbbbbbbbbbbbbbb0
00000000bb0065577557770bbb0065577557770bb0666557655650bbbbbbbbbbbbbbb0000000bbbbbbbbbbbbbbbbb0000000bbbbbbbbbbbbbbbbbbbbbbbbbbb0
00000000bbb00556755570bbbbb00556755570bbbb0005566555560bbbbbbbbbbbbbbbb000bbbbbbbbbbbbbbbbbbbbb000bbbbbb8bbbbbbbbbbbbb8bbbbbbbb0
00000000bbbbb05566550bbbbbbbb05566550bbbbbbb005555606560bbbbbbbbbbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbb0bbbbbbbbbbbbbbbbbbbb888bbbbbb00
00000000bbbbbb000000bbbbbbbbbb000000bbbbbbbbb00006560650bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbb8bbbbbbb00
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0656000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0660bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbb8bbbbbbb00
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbb00
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb888bbbbbbbbbbbbbbbbbbb00
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000b8bbbbbbbbbbbbbbbbbbbb00
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000bbbbbbbbbbbbbbb8bbbbbb00
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000bbbbbbbbbbbbbbbbbbbbbb00
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000008bbbbbbbbbbbbbbbbbbbbb00
0000000bbbbbb00000bbbbbbbbbbb00000bbbbbbbbbbbbbbbbbbbbbb000000bbbbbbbbbb000000bbbbbbbbb00000000000000000bbbbbbbbbbbbbb8bbbbbbb00
0000000bbbbbb06660bbbbbbbbbbb06660bbbbbbbbbbbbbbbb00000b0888880bbb00000b0888880bbbbbbbb00000000000000000bbbbbbbbbbbbbbbbbbbbbb00
0000000bbbbbb066660b0000bbbbb066660b0000bbbbbbbbb008888008888800b008888008888800bbbbbbb00000000000000000bbbbbbbbbbbbbbbbbbbbbb00
0000000bbbb0006666000660bbb0006666000660bbbbbbbbb088880000088880b088880000088880bbbbbbb00000000000000000bbbbbbbbbbbbbbbbbbbbbb00
0000000bb006600000006660b006600000006660bbbbbbbbb088807777708880b088807777708880bbbbbbb00000000000000000bbbbbbbbbbbbbb8bbbbbbb00
0000000b06660555555506600666055555550660bbbbbbbbb088007777700880b088077070770880bbbbbbb00000000000000000bbbbbbbbbbbbb8b8bbbbbb00
0000000b06605055555050600660555050555060bbbbbbbbb080770777077080b080777070777080bbbbbbb000000000000000008bbbbbbbbbbbbb8bbbbbbb00
0000000b06605505550550600660555050555060bbbbbbbb00007700700770800000777777777080bbbbbbb00000000000000000bbbbbbbbbbbbbbbbbbbbbb00
0000000b06605500500550000660555555555000bbbbbbbb08807777777770000880770777077000bbbbbbb00000000000000000000bbbbbbbbbbbbbbbbbbb00
0000000bb000555555555060b000550555055060bbbbbbbb088077700077708008807770007770800bbbbbb00000000000000000000bbbbbbbbbbbbbbbbbbb00
0000000bbb00555000555060bb00555000555060bbbbbbbb088807777777088008880777777708880bbbbbb00000000000000000000bbbbbbbbbbbbbbbbbbb00
0000000bb006005555550660b006005555550660bbbbbbbb088880777770888008888077777088880bbbbbb00000000000000000000bbbbbbbbbbbbbbbbbbb00
0000000bb066660000006660b066660000006660bbbbbbbb088888000000888008888800000088880bbbbbb00000000000000000000bbbbbbbbbbbbbbbbbbb00
0000000bb066600666600600b066600666600600bbbbbbbb000000888888088000000088888808800bbbbbb00000000000000000000bbbbbbbbbbbbbbbbbbb00
0000000bb00000066660000bb00000066660000bbbbbbbbbbbbbb00888800000bbbbb00888800000bbbbbbb00000000000000000000bbbbbbbbbbbbbbbbbbb00
0000000bbbbbbb000000bbbbbbbbbb000000bbbbbbbbbbbbbbbbbb000000bbbbbbbbbb000000bbbbbbbbbbb00000000000000000000bbbbbbbbbbbbbbbbbbb00
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000
0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbb8bbbbbbbbbbbbbbbbbbbbbbb8bbbbbbb8bbbbbbbbbbbbbbbbbbbbbbb8bb00000000000000000000000000000000000000000000000000000000
00000000bbbb888bbbbbbbbbbbbbbbbb8bbbbbbbbbbb8b8bbbbbbbbbbbbbbbbb8bbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbb8bbbbb8bbbbbbbbbbbbbbbbbbbbbbbbb8bbbbb8bbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbb8b8bbbbbbbbbbbbbbbbbbbbbbbbbbbbb888bbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bb00000000000000000000000000000000000000000000000000000000
00000000bb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8b00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbb8b8bbbbbbbbbbbbbbbbbbbbbbbbbbbbb888b00000000000000000000000000000000000000000000000000000000
00000000bb8bbbbbbbbbbbbbbbbbbbbbbbbbb8bbbb8bbbbbbbbbbbbbbbbbbbbbbbbbb8bb00000000000000000000000000000000000000000000000000000000
00000000bbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbb00000000000000000000000000000000000000000000000000000000
__map__
0505050505050505050505050505050505050505050505050505050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505060706070607060706070607060706060706070607060705050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0512010c01010101010101010d0101010201010d010101020c0e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05110101010d0101010c0101010101010d01010101010a0d0d0e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0512010d0101090101010d010b0108020101010b010d0201010f050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05110101010b01010d010101010d0101010101010d0101010c0e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
051201020a0c020101010201010101010102010101090b01010f050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0511010d0c0d0c010101010d0102010d010101010d010d01010e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05120102090101010d0101010101010c0b01010101010101010f050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0511010d0101010101010101010c0a0101010102010d0101010e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05120d01010d01080101020101090d010d01010d010c0802010f050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
051101010b010102010101010101010c0c0d0101010b0c0c010e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0512010201010d010c010d010a010c010d01010b010d01090d0e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0512010d0102010d0101010101010101010d01010d010101020f050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0512010101010101010101010101010c0d01010102010c0d010f050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505030403040303040304030403040303040304030403030405050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050505050505050505050505050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00080000387000f710197201e7302a7502e7003a70032700365002c7002d0002070028500157002d00002700207000170027700300000770025000290002870032000227002450029750267401f7301372006710
0019000006510075100752038500055100551005520385000a5100a5100a5302b5000552005520045201b5000d5100e5300e53009510035000652004520045200252000510025100551007530035200252000500
0019000006710077100774038700057100571005750387000a7100a7100a7502b7000571005720047301b7000d7100e7200e74009710037000673004730047200272000710027100573007740037300271000700
00231f1f000002e0102f010000003801039010000003d0103b0103b0103d0102b0003a0103a010000003401033010000002a0100000030010250102a000220101a0102a00015010000000e010000000a01000000
0019000000770017700177002770047700577006770007701177000770007700b7700077007770057700677000770027700477008770067700077008770007700a7700b7700c7700677007770107700477000770
__music__
03 01024344

