local monitor = peripheral.find("monitor")

-- List of video files to cycle through
local videoFiles = {"/video1.nfv", "/video2.nfv", "/video3.nfv"}  -- Add more files as needed

-- Function to load video data from a file
local function loadVideo(videoFile)
    local videoData = {}
    for line in io.lines(videoFile) do
        table.insert(videoData, line)
    end

    -- Get resolution and fps from the first line
    local resolution = { videoData[1]:match("(%d+) (%d+)") }
    local fps = tonumber(videoData[1]:match("%d+ %d+ (%d+)"))
    table.remove(videoData, 1)  -- Remove the first line, which is metadata

    return videoData, resolution, fps
end

-- Function to display the next frame
local function nextFrame(videoData, resolution, fps, frameIndex)
    local frame = {}
    for i = 1, resolution[2] do
        if frameIndex + i > #videoData then
            return false, frameIndex  -- End of video, return false to stop
        end
        table.insert(frame, videoData[frameIndex + i])
    end
    local parsedFrame = paintutils.parseImage(table.concat(frame, "\n"))
    frameIndex = frameIndex + resolution[2]
    paintutils.drawImage(parsedFrame, 1, 1)
    os.sleep(1 / fps)
    return true, frameIndex  -- Continue playing
end

-- Function to play a video file
local function playVideo(videoFile)
    local videoData, resolution, fps = loadVideo(videoFile)
    local frameIndex = 2  -- Start reading video data from the second line (skip metadata)

    while true do
        local success
        success, frameIndex = nextFrame(videoData, resolution, fps, frameIndex)
        
        -- If we reach the end of the video, return to the beginning
        if not success then
            return  -- Exit the loop, signaling the end of the video
        end
    end
end

-- Function to cycle through multiple videos
local function cycleVideos()
    local videoIndex = 1

    while true do
        local currentVideoFile = videoFiles[videoIndex]
        print("Now playing: " .. currentVideoFile)
        
        -- Play the current video
        playVideo(currentVideoFile)

        -- Move to the next video file in the list
        videoIndex = videoIndex + 1
        if videoIndex > #videoFiles then
            videoIndex = 1  -- Restart the cycle from the first video
        end
    end
end

-- Set up the monitor and redirect the output
monitor.setTextScale(1)
term.redirect(monitor)

-- Start cycling through the video files
cycleVideos()

-- Reset terminal once done
term.clear()
term.redirect(term.native()


-- local dfpwm = require("cc.audio.dfpwm")

-- local speaker = peripheral.find("speaker")
-- local monitor = peripheral.find("monitor")

-- local videoFile = "/video.nfv"
-- local audioFile = "/audio.dfpwm"

-- local videoData = {}
-- for line in io.lines(videoFile) do
--     table.insert(videoData, line)
-- end

-- local resolution = { videoData[1]:match("(%d+) (%d+)") }
-- local fps = tonumber(videoData[1]:match("%d+ %d+ (%d+)"))
-- table.remove(videoData, 1)

-- local frameIndex = 2
-- function nextFrame()
--     local frame = {}
--     for i = 1, resolution[2] do
--         if frameIndex + i > #videoData then
--             break
--         end
--         table.insert(frame, videoData[frameIndex + i])
--     end
--     frame = paintutils.parseImage(table.concat(frame, "\n"))
--     frameIndex = frameIndex + resolution[2]
--     if frameIndex > #videoData then
--         return false
--     end

--     paintutils.drawImage(frame, 1, 1)
--     os.sleep(1 / fps)
--     return true
-- end

-- monitor.setTextScale(1)
-- term.redirect(monitor)

-- function audioLoop()
--     local decoder = dfpwm.make_decoder()
--     for chunk in io.lines(audioFile, 16 * 1024) do
--         local buffer = decoder(chunk)
--         while not speaker.playAudio(buffer, 3) do
--             os.pullEvent("speaker_audio_empty")
--         end
--     end
-- end

-- function videoLoop()
--     while nextFrame() do end
-- end

-- parallel.waitForAll(audioLoop, videoLoop)

-- term.clear()
-- term.redirect(term.native())
