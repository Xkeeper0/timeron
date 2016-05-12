
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
			bignumbers	= love.graphics.newImageFont("numberfont-alt.png", "0123456789 .x-:"),
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

		currentMode	= modes.timer

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

		love.graphics.setBackgroundColor(30, 30, 70)
		love.graphics.setColor(255, 255, 255)

		local currentTime	= os.date("*t")

		love.graphics.print(string.format("%02d:%02d:%02d", currentTime.hour, currentTime.min, currentTime.sec), textX, textY, 0, scale, scale)

	end

	modes.timer.keypressed	= function (key, rpt) end




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
		local fontWidth		= font:getWidth("00:00:00");
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
