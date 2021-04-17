-- kitns
-- sample kit creator for norns 
-- by @fardles
--
-- 1. Load source folder in params
-- 2. Name new kit
-- 3. E2 to scroll through samples
-- 4A. K2 to select
-- 4B. K3 to unselect
-- 5. K1 + K2 to create new kit
--
-- New kit folder in 
--    dust/audio/kitns
-- Selected samples copied


local NUM_SAMPLES = 99

-- local sample_status = {}
-- local STATUS = {
--   STOPPED = 0,
--   STARTING = 1,
--   PLAYING = 2,
--   STOPPING = 3
-- }

local sample_bank = {}
sample_bank.pos = 0
local loaded_folder = ''
local new_kit_name = nil
local new_kit_folder = nil
local current_sample_id = 0
local err_msg = nil
local saved_kit = 0

-- for i = 0, NUM_SAMPLES - 1 do sample_status[i] = STATUS.STOPPED end


local file_select_active = false

local Timber = include("timber/lib/timber_engine")
engine.name = "Timber"
local MusicUtil = require "musicutil"
local Audio = require "audio"
local fileselect = require('fileselect')
local UI = require('ui')
local util = require('util')
local textentry = require('textentry')

-- Init

function init ()
  
  --Turn reverb off
  Audio.rev_off()
  
  -- Params
  params:add_trigger('load_f','+ Load Folder')
  params:set_action('load_f', function() Timber.FileSelect.enter(_path.audio, function(file)
  if file ~= "cancel" then load_folder(file, add) end end) end)

  params:add_trigger('add_new_kit_name', '+ New Kit Name')
  params:set_action('add_new_kit_name', function() textentry.enter(new_kit_callback,"", "new kit name:",check) end)
  
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
  sample_bank = {}
  sample_bank.pos = 0

  local split_at = string.match(file, "^.*()/")
  local folder = string.sub(file, 1, split_at)
  file = string.sub(file, split_at + 1)
  
  local found = false
 
  for k, v in ipairs(Timber.FileSelect.list) do
    if v == file then found = true end
    if found then
      if sample_id > 99 then
        print("Max files loaded")
        break
      end
      -- Check file type
      local lower_v = v:lower()
      if string.find(lower_v, ".wav") or string.find(lower_v, ".aif") or string.find(lower_v, ".aiff") then
        Timber.load_sample(sample_id, folder .. v)
        params:set('play_mode_' .. sample_id, 4)
        
        -- Truncated folder name
        
        loaded_folder = folder
        loaded_folder_trunc = string.sub(folder,14, split_at)
        print(loaded_folder)
        
        -- Insert into sample bank table
        table.insert(sample_bank, {name = v, original_folder = folder, id = sample_id, selected = 0})
        print(sample_bank[sample_id+1].name)
        sample_id = sample_id + 1
      
      else
        print("Skipped", v)
      end
    end
  end
  redraw()
end
  

-- Sample management function

local function set_sample_id(id)
  current_sample_id = id
  while current_sample_id + 1 > #sample_bank do current_sample_id = #sample_bank - 1 end
  while current_sample_id < 0 do current_sample_id = 0 end
end

-- Sample playing function

local function note_on(sample_id, vel)
  if Timber.samples_meta[sample_id].num_frames > 0 then
    -- print("note_on", sample_id)
    vel = vel or 1
    engine.noteOn(sample_id, MusicUtil.note_num_to_freq(60), vel, sample_id)
    -- sample_status[sample_id] = STATUS.PLAYING
  end
end

-- New Kit

  -- New kit name

new_kit_callback = function(txt)
    new_kit_name = txt
    print(new_kit_name)
end

  -- Create new kit
  
function create_new_kit()
  saved_kit = 0
  -- Sanitise folder and file names
  
  local new_kit_name_s = new_kit_name:gsub(" ","\\ ")
  for i,v in ipairs(sample_bank) do
    sample_bank[i].name_s = sample_bank[i].name:gsub(" ","\\ ")
  end
  local loaded_folder_s = loaded_folder:gsub(" ","\\ ")
  
  -- new folder 
  
  if new_kit_name ~= nil then
    new_kit_folder = _path.audio..'kitns/'..new_kit_name_s..'/'
    local cmd = 'mkdir -p '..new_kit_folder
    print(cmd)
    os.execute(cmd)
    
  --  empty folder if existing 
  
    -- local cmd = 'rm -rf '..new_kit_folder..'/*'
    -- os.execute(cmd)
    
  -- copy selected to new folder 
    
    for i,v in ipairs(sample_bank) do
      if sample_bank[i].selected == 1 then
        local cmd = 'cp '..loaded_folder_s..sample_bank[i].name_s.." "..new_kit_folder
        print("Copying "..sample_bank[i].name_s.." from "..loaded_folder_s.." to "..new_kit_folder)
        os.execute(cmd)
      end
    end
    saved_kit = 1
  -- if no new kit specified
  else
    print("Error: No new kit named.")
    err_msg = "kit_name_error"
  end
end
  
  
-- Encoder input

function enc(n,d)
  if n == 2 then
    
     -- Play sample upon E2 turn reaching sample 
     
    engine.noteOffAll()
    engine.noteKillAll()
    current_sample_id = current_sample_id + d
    if current_sample_id < 0 then current_sample_id = 0
    elseif current_sample_id + 1 > #sample_bank then current_sample_id = #sample_bank -1 end
    set_sample_id(current_sample_id)
    note_on(current_sample_id)
    
    -- Update position in list
  
    sample_bank.pos = sample_bank.pos + d
    if sample_bank.pos < 0 then sample_bank.pos = 0 end
    if sample_bank.pos + 1 > #sample_bank then sample_bank.pos = #sample_bank - 1 end
  end
redraw()
end

-- Key input

function key(n,z)
  saved_kit = 0
  if err_msg == nil then
    if n == 1 then
      alt = z==1
    elseif n == 2 and z == 1 then
      
      -- K2 selects sample
      
      if not alt == true then
          if #sample_bank ~= 0 then
            sample_bank[current_sample_id+1].selected = 1
            print("Sample "..sample_bank[current_sample_id+1].name.." selected.")
          elseif #sample_bank == 0 then
            err_msg = "no_files_error"
          end
          
      -- Alt K2 creates new kit
      
      elseif alt == true then
        create_new_kit()
      end
    elseif n == 3 and z == 1 then
      
      -- K3 unselects sample 
      
      if not alt == true then
          if #sample_bank ~= 0 then
            sample_bank[current_sample_id+1].selected = 0
            print("Sample "..sample_bank[current_sample_id+1].name.." unselected.")
          elseif #sample_bank == 0 then
            err_msg = "no_files_error"
          end
          
      -- Alt K3 no function yet
      
      elseif alt == true then
      end
    end
    
    -- Escape error message
    
  elseif err_msg ~= nil then
    if n == 1 or 2 or 3 then
      err_msg = nil
    end
  end
redraw()
end

-- Screen

function redraw()
  if err_msg == nil then
    screen.clear()
    screen.font_face(1)
    screen.font_size(8)
    if new_kit_name == nil then
      screen.level(2)
      screen.move(0,20)
      screen.text("D: No new kit named")
    elseif new_kit_name ~= nil then
      screen.level(2)
      screen.move(0,20)
      screen.text("D: /audio/kitns/"..new_kit_name)
    end
    if #sample_bank == 0 then
      screen.level(2)
      screen.move(0,10)
      screen.text("O: (no files)")
    else
      screen.level(2)
      screen.move(0,10)
      screen.text("O: "..loaded_folder)
      for i=1,5 do
        if (i > 2 - sample_bank.pos) and (i < #sample_bank - sample_bank.pos + 3) then
          local list_index = i+sample_bank.pos-2
          screen.move(10,20+10*i)
          if(i==3) then
            screen.level(15)
          else
            screen.level(4)
          end
          screen.text(sample_bank[list_index].name)
          if sample_bank[list_index].selected == 1 then
            screen.move (0,20+10*i)
            screen.level(15)
            screen.text("+")
          end
        end
      end
    end
    -- screen.move(120,50)
    -- screen.level(15)
    -- screen.text(current_sample_id)
    -- screen.move(120,60)
    -- screen.level(15)
    -- screen.text(sample_bank.pos)
  elseif err_msg == 'kit_name_error' then
    screen.font_size(8)
    screen.clear()
    screen.move(0,32)
    screen.level(15)
    screen.text("ERROR: No new kit named.")
    screen.move(0,42)
    screen.text("Name new kit in params.")
  elseif err_msg == 'no_files_error' then
    screen.font_size(8)
    screen.clear()
    screen.move(0,32)
    screen.level(15)
    screen.text("ERROR: No samples loaded.")
    screen.move(0,42)
    screen.text("Load sample folder in params.")
  end 
  
  if saved_kit == 1 then
    screen.move(120,63)
    screen.text("S")
  end
  screen.update()
end


