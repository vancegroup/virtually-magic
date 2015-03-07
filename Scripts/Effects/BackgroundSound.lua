--print("Loading PlaySound.lua. Wav files must be 16bit float.")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())

--Wav files must be 16 bit float
local SoundWav = function(wavPath)
	snx.changeAPI("OpenAL")
	--create a sound info object 
	local soundInfo = snx.SoundInfo()
	-- set the filename attribute of the soundFile (path to your sound file)
	soundInfo.filename = wavPath
	--create a new sound handle and pass it the filename from the soundInfo object
	local soundHandle = snx.SoundHandle(soundInfo.filename)
	--configure the soundHandle to use the soundInfo
	soundHandle:configure(soundInfo)
	--play or "trigger" the sound
	return soundHandle
end

local SoundMp3 = function(mp3Path)
	snx.changeAPI("Audiere")
	--create a sound info object 
	local soundInfo = snx.SoundInfo()
	-- set the filename attribute of the soundFile (path to your sound file)
	soundInfo.filename = mp3Path
	--create a new sound handle and pass it the filename from the soundInfo object
	local soundHandle = snx.SoundHandle(soundInfo.filename)
	--configure the soundHandle to use the soundInfo
	soundHandle:configure(soundInfo)
	--play or "trigger" the sound
	return soundHandle
end

function startBackgroundSound()
	Actions.addFrameAction(
		function()
			local my_sound = SoundWav(vrjLua.findInModelSearchPath("Sound/magic3.wav"))
			while true do
				--loop and play the sound over and over
				if (my_sound.isPlaying == false) then
					print("Triggering sound.")
					my_sound:trigger(1)
				end
				Actions.waitForRedraw()
			end
		end
	)
end

local slide = SoundWav(vrjLua.findInModelSearchPath("Sound/painting.wav"))
function PlayPainting()
	slide:trigger(1)
	print("slide")
end

local disappear = SoundWav(vrjLua.findInModelSearchPath("Sound/bookshelf.wav"))
function PlayBookshelf()
	disappear:trigger(1)
end

local dementor = SoundWav(vrjLua.findInModelSearchPath("Sound/dementor.wav"))
function PlayDementor()
	dementor:trigger(1)
end

local lumos = SoundWav(vrjLua.findInModelSearchPath("Sound/lumos.wav"))
function PlayLumos()
	lumos:trigger(1)
end

function offLumos()
	lumos:stop()
end

local draw = SoundWav(vrjLua.findInModelSearchPath("Sound/draw.wav"))
function PlayDraw()
	draw:trigger(1)
end

function offDraw()
	draw:stop()
end

startBackgroundSound()