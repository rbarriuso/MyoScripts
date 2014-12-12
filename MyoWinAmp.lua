-- WinAmp gestire control with Myo
-- Supported gestures:
--   Fist = play
--   FingersSpread = pause / play
--   WaveIn = prev track
--   WaveOut = next track

scriptId = 'com.tribalyte.myo.winampgesture'
scriptTitle = "WinAmp control"
scriptDetailsUrl = "" -- We don't have this until it's submitted to the Myo Market

function conditionallySwapWave(pose)
    if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

function winampPlay()
	myo.keyboard("x", "press")
	return true
end

function winampPausePlay()
	myo.keyboard("c", "press")
	return true
end

function winampNextTrack()
	myo.keyboard("b", "press")
	return true
end

function winampPrevTrack()
	myo.keyboard("z", "press")
	return true
end


-- Myo Connect callbacks:

function onPoseEdge(pose, edge)
    myo.debug("Pose: " .. pose .. ", " .. edge)
	
	local consumed = false;
	if edge == "on" then
		pose = conditionallySwapWave(pose)
		if pose == "doubleTap" then
			myo.lock()
			consumed = true;
		elseif pose == "fist" then
			consumed = winampPlay()
		elseif pose == "fingersSpread" then
			consumed = winampPausePlay()
		elseif pose == "waveIn" then
			consumed = winampPrevTrack()
		elseif pose == "waveOut" then
			consumed = winampNextTrack()
		end
	end
	
	if consumed then
		myo.debug("Notify user action")
		myo.notifyUserAction()
	end
	
end

function onUnlock()
	myo.debug("Unlocked")
	myo.unlock("hold")
end

function onLock()
	myo.debug("Locked")
end

function onForegroundWindowChange(app, title)
    myo.debug("Fore change: " .. app .. ", " .. title)
	--TODO: detect winap status (playing, paused) via the window title
	return platform == "MacOS" and app == "??????" or --TODO: support MacOS?
       platform == "Windows" and app == "winamp.exe"
end

function activeAppName()
    return "WinAmp"
end

function onActiveChange(isActive)
	if isActive then
		myo.debug("WinAmp script active")
	end
end
