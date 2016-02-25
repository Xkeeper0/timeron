
	scale	= 20
	at		= 0
	gt		= 0
	textX	= 0
	textY	= 0

	function love.load()

		--font		= love.graphics.setNewFont(500)
		love.graphics.setDefaultFilter("nearest", "nearest", 1)
		bignumbers	= love.graphics.newImageFont("numberfont-2x.png", "0123456789 .x")
		love.graphics.setFont(bignumbers)

		love.window.setMode(0, 0, {
				fullscreen		= true,
				fullscreentype	= "desktop",
				vsync			= false,
				})
		local w, h, f	= love.window.getMode()

		local padding	= 100
		local tScale	= math.floor((w - padding) / 34)
		textX			= ((w) - tScale * 34) / 2
		textY			= (h - (tScale * 16)) / 2
		scale			= tScale

		local low		= love.audio.newSource("low.wav", "static")
		local high		= love.audio.newSource("high.wav", "static")

		beep	= 99
		beeps	= {
			{ time = -60, sound = high },
			{ time = -33, sound = low },
			{ time = -32, sound = low },
			{ time = -31, sound = low },
			{ time = -30, sound = high },
			{ time =  -3, sound = low },
			{ time =  -2, sound = low },
			{ time =  -1, sound = low },
			{ time =   0, sound = high },
		}

	end


	function love.update(dt)
		gt	= gt + dt
	end


	function love.draw()
		local vt	= gt - at

		local dvt	= math.min(99, math.floor(math.abs(vt)))

		if beeps[beep] and beeps[beep].time < vt then
			beeps[beep].sound:play()
			beep = beep + 1
		end

		if vt < -30 then
			love.graphics.setBackgroundColor(50, 50, 50)

		elseif vt < 0 then
			love.graphics.setBackgroundColor(30, 30, 70)

		else
			love.graphics.setBackgroundColor(70, 30, 30)

		end

		love.graphics.print(string.format("%02d", dvt), textX, textY, 0, scale, scale)
		--love.graphics.printf(string.format("x%d", (totalChain or 0) * (currentChain or 0)), 300, 120, 100, "right")

	end




	function love.keypressed(key, rpt)

		if key == "escape" then
			love.event.quit()
		end

		if key == " " then
			at		= gt + 60
			beep	= 1
		end

	end