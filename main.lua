
	scale			= 1
	targetTime		= 0
	globalTime		= 0
	textX			= 0
	textY			= 0
	setTime			= 60
	setTimeDisplay	= 0
	padding			= 20
	timerActive		= false
	oldWindow		= {}

	defualtHelpText	= "escape: quit - f: toggle fullscreen - "

	function love.load()

		love.graphics.setDefaultFilter("nearest", "nearest", 1)

		fonts		= {
			bignumbers	= love.graphics.newImageFont("numberfont-2x.png", "0123456789 .x-:"),
			helptext	= love.graphics.newFont(12)
			}

		love.graphics.setFont(fonts.bignumbers)

		windowWidth, windowHeight, windowFlags	= love.window.getMode()
		rescaleFont(windowWidth, windowHeight)

		local low		= love.audio.newSource("low.wav", "static")
		local high		= love.audio.newSource("high.wav", "static")

		beep	= 99
		beeps	= {
			{ time = -9999, sound = low },
			{ time =     0, sound = high },
		}

		currentMode	= modes.set

	end


	function love.update(dt)
		globalTime	= globalTime + dt
	end


	function love.draw()
		currentMode.draw()
	end


	modes	= {}
	modes.timer	= {}
	modes.timer.draw	= function()
		local localTimer	= globalTime - targetTime


		local displayTimer	= math.min(100 * 60 - 1, math.floor(math.abs(localTimer)))

		if not timerActive then
			localTimer		= 100 * 60 - 1
			displayTimer	= setTime
			beep			= false
		end

		if beeps[beep] and beeps[beep].time < localTimer then
			beeps[beep].sound:play()
			beep = beep + 1
		end

		if not timerActive then
			love.graphics.setBackgroundColor(40, 40, 40)
			love.graphics.setColor(180, 180, 180)
		
		elseif localTimer < 0 then
			love.graphics.setBackgroundColor(30, 30, 70)
			love.graphics.setColor(255, 255, 255)

		else
			love.graphics.setBackgroundColor(50, 10, 10)
			love.graphics.setColor(255, 120, 120)

		end

		local displayM	= math.floor(displayTimer / 60)
		local displayS	= displayTimer % 60

		love.graphics.print(string.format("%02d:%02d", displayM, displayS), textX, textY, 0, scale, scale)
		displayHelpText(defualtHelpText .. "space: start/stop - enter: change setting")

	end

	modes.timer.keypressed	= function (key, rpt)
		if key == "space" then
			targetTime		= globalTime + setTime
			timerActive		= not timerActive
			beep	= 1
			return

		elseif key == "return" then
			timerActive		= false
			currentMode		= modes.set

		end

	end


	modes.set	= {}
	modes.set.draw	= function()

		love.graphics.setBackgroundColor(50, 70, 50)
		love.graphics.setColor(255, 255, 255)

		local disp	= string.gsub(string.format("%4d", setTimeDisplay), " ", "-")
		if setTimeDisplay == 0 then
			disp	= "----"
		end
		local disp1	= disp:sub(1, 2)
		local disp2	= disp:sub(3, 4)

		love.graphics.print(string.format("%2s:%2s", disp1, disp2), textX, textY, 0, scale, scale)

		displayHelpText(defualtHelpText .. "enter: save - 0-9, backspace: change time setting")

	end

	do
		local keymap	= {}
		for i = 0, 9 do
			keymap[tostring(i)]			= i
			keymap["kp"..tostring(i)]	= i
		end

		modes.set.keypressed	= function (key, rpt)
			if keymap[key] then
				setTimeDisplay	= math.min(9959, setTimeDisplay * 10 + keymap[key])
				return

			elseif key == "backspace" then
				setTimeDisplay	= math.floor(setTimeDisplay / 10)
				return

			elseif key == "return" then
				local setS	= setTimeDisplay % 100
				local setM	= math.floor(setTimeDisplay / 100)
				if setS >= 60 then
					setM	= setM + 1
					setS	= setS - 60
				end

				setTime		= setM * 60 + setS
				
				currentMode	= modes.timer
			end
		end

	end



	function love.keypressed(key, rpt)

		if key == "escape" or key == "q" then
			love.event.quit()
			return

		elseif key == "f" then
			toggleFullscreen()

		end

		currentMode.keypressed(key, rpt)

	end


	function toggleFullscreen()
		windowWidth, windowHeight, windowFlags	= love.window.getMode()
		
		if windowFlags.fullscreen then
			-- Fullscreen, restore old
			windowFlags.fullscreen	= false
			love.window.setMode(oldWindow.w, oldWindow.h, windowFlags)
		
		else
			-- Windowed, save old and go fullscreen
			oldWindow.w, oldWindow.h	= windowWidth, windowHeight
			windowFlags.fullscreen	= true
			love.window.setMode(0, 0, windowFlags)

		end

		windowWidth, windowHeight, windowFlags	= love.window.getMode()
		rescaleFont(windowWidth, windowHeight)

	end

	function love.resize(w, h)
		windowWidth, windowHeight	= w, h
		rescaleFont(w, h)
	end

	function rescaleFont(w, h)
		-- Get font required width/height
		local font			= love.graphics.getFont()
		local fontWidth		= font:getWidth("00:00");
		local fontHeight	= font:getHeight();

		-- Available size for font
		local aWidth	= w - padding * 2
		local aHeight	= h - padding * 2

		-- Get the biggest scaling text can support
		scale		= math.floor(math.min( aWidth / fontWidth , aHeight / fontHeight ) )

		textX			= (w - scale * fontWidth) / 2
		textY			= (h - scale * fontHeight) / 2

	end



	function displayHelpText(msg)
		local oldFont	= love.graphics.getFont()
		love.graphics.setFont(fonts.helptext)
		love.graphics.printf(msg, 0, windowHeight - 20, windowWidth, "center")
		love.graphics.setFont(oldFont)

	end
