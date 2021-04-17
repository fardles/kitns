-- kitns
-- a sample kit manager for norns by @fardles
-- KITs for NornS


local fileselect = require('fileselect')
local NUM_SAMPLES = 99

local sample_status = {}
local STATUS = {
  STOPPED = 0,
  STARTING = 1,
  PLAYING = 2,
  STOPPING = 3
}
for i = 0, NUM_SAMPLES - 1 do sample_status[i] = STATUS.STOPPED end

local current_sample_id = 0
local file_select_active = false

local Timber = include("timber/lib/timber_engine")
engine.name = "Timber"
local MusicUtil = require "musicutil"
local Audio = require "audio"

-- Init

function init ()
  
  --Turn reverb off
  Audio.rev_off()
  
  -- Params
  params:add_trigger('load_f','+ Load Folder')
  params:set_action('load_f', function() Timber.FileSelect.enter(_path.audio, function(file)
  if file ~= "cancel" then load_folder(file, add) end end) end)

  Timber.options.PLAY_MODE_BUFFER_DEFAULT = 3
  Timber.options.PLAY_MODE_STREAMING_DEFAULT = 3
  params:add_separator()
  Timber.add_params()
  for i = 0, NUM_SAMPLES - 1 do
    local extra_params = {
      {type = "option", id = "launch_mode_" .. i, name = "Launch Mode", options = {"Gate", "Toggle"}, default = 1, action = function(value)
        Timber.setup_params_dirty = true
      end},
    }
    params:add_separator()
    Timber.add_sample_params(i, true, extra_params)
  end
  redraw()
end

-- Sample loading function (borrowed from nisp)

function load_folder(file, add)
  
  local sample_id = 0
  if add then
    for i = NUM_SAMPLES - 1, 0, -1 do
      if Timber.samples_meta[i].num_frames > 0 then
        sample_id = i + 1
        break
      end
    end
  end

  Timber.clear_samples(sample_id, NUM_SAMPLES - 1)

  local split_at = string.match(file, "^.*()/")
  local folder = string.sub(file, 1, split_at)
  file = string.sub(file, split_at + 1)
  
  local found = false
  for k, v in ipairs(Timber.FileSelect.list) do
    if v == file then found = true end
    if found then
      if sample_id > 35 then
        print("Max files loaded")
        break
      end
      -- Check file type
      local lower_v = v:lower()
      if string.find(lower_v, ".wav") or string.find(lower_v, ".aif") or string.find(lower_v, ".aiff") then
        Timber.load_sample(sample_id, folder .. v)
        params:set('play_mode_' .. sample_id, 4)
        sample_id = sample_id + 1
      else
        print("Skipped", v)
      end
    end
  end
end

-- Sample management function

--TODO: Change NUM_Samples to the number of samples actually loaded? Or just 0

local function set_sample_id(id)
  current_sample_id = id
  while current_sample_id >= NUM_SAMPLES do current_sample_id = current_sample_id - NUM_SAMPLES end
  while current_sample_id < 0 do current_sample_id = current_sample_id + NUM_SAMPLES end
end

-- Sample playing function

local function note_on(sample_id, vel)
  if Timber.samples_meta[sample_id].num_frames > 0 then
    -- print("note_on", sample_id)
    vel = vel or 1
    engine.noteOn(sample_id, MusicUtil.note_num_to_freq(60), vel, sample_id)
    sample_status[sample_id] = STATUS.PLAYING
  end
end

local function note_off(sample_id)
  -- print("note_off", sample_id)
  engine.noteOff(sample_id)
end


local function note_off_all()
  engine.noteOffAll()
end

local function note_kill_all()
  engine.noteKillAll()
end

-- Encoder input

function enc(n,d)
  if n == 2 then
    note_kill_all()
    set_sample_id(current_sample_id+d)
    if current_sample_id < 0 then current_sample_id = 0 end
    note_on(current_sample_id)
  end
  redraw()
end

-- Screen

function redraw()
  screen.clear()
  screen.move(10,10)
  screen.level(15)
  screen.text(current_sample_id)
  screen.update()
end


