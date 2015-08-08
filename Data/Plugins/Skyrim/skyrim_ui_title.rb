#==============================================================================
# • Skyrim UI - Title : Dax.
#==============================================================================
# 1.0 :
#	- Versão inicial. Comandos básicos.
#==============================================================================
Dax.register(:skyrim_ui_title, "dax", 1.0, [[:skyrim_ui, "dax", 3.0],
            [:mouse_window_selectable, "dax"]]) {

	#==========================================================================
	# • Remover:
	#==========================================================================
	Dax.remove(:Scene_Title)
	#==========================================================================
	# • Scene_Title : Skyrim UI
	#==========================================================================
	class Scene_Title < Scene_Base
		#----------------------------------------------------------------------
		# • Incluir o módulo Skyrim.
		#----------------------------------------------------------------------
		include Skyrim
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		def start
			super
			setup
			create_icon
			create_option
			create_skin
			create_window_savefile
			play_title_music
		end
		#----------------------------------------------------------------------
		# • Configueração das variáveis.
		#----------------------------------------------------------------------
		def setup
			@time_for_particle = TITLE[:PARTICLE][:TIME_NEW]
			@option = []
			@active_skin = false
			@continue_active = false
			@skin_pos = TITLE[:POS][:SKIN_UI]
		end
		#----------------------------------------------------------------------
		# • Criar o ícone.
		#----------------------------------------------------------------------
		def create_icon
			@icon = Sprite.new
			@icon.bitmap = Cache.skyrim(TITLE[:GRAPHIC][:ICON_LOGO])
			@icon.z = 200
			@icon.position(:center_left)
			@icon.x += TITLE[:POS][:ICON_ADD].x
			@icon.y += TITLE[:POS][:ICON_ADD].y
		end
		#----------------------------------------------------------------------
		# • Criar as opções.
		#----------------------------------------------------------------------
		def create_option
			TITLE[:OPTION].each_with_index do |data, n|
			    _pos = Position.new(TITLE[:POS][:OPTION].x, (FONT[:BUTTON][:SIZE] + 1) * n)
				_pos.y += TITLE[:POS][:OPTION].y
				@option[n] = Button.new(_pos, data[:title], :DEFAULT, 2)
				@option[n].opacity = 0
				@option[n].handler = data[:handler]
			end
		end
		#----------------------------------------------------------------------
		# • Criar Skin:
		#----------------------------------------------------------------------
		def create_skin
			@skin = SkinUI.new([@skin_pos.x, 0], 164, Graphics.height)
			@skin.opacity = 0
			@skin.visible = @active_skin
		end
		#----------------------------------------------------------------------
		# • Criar janela Window_SaveFile
		#----------------------------------------------------------------------
		def create_window_savefile
			@window_savefile = Window_LoadList.new(@skin.x, @skin.y, @skin.width, @skin.height)
			@window_savefile.z = @skin.z+1
			@window_savefile.visible = @skin.visible
			@window_savefile.active = false
			@window_savefile.set_handler(:ok, method(:load_on))
			@window_savefile.set_handler(:cancel, method(:load_cancel))
		end
		#----------------------------------------------------------------------
		# • Deletar os objetos.
		#----------------------------------------------------------------------
		def terminate
			super
			[@icon, @skin].each(&:dispose)
			@option.each(&:dispose)
			Particle.clear
		end
		#----------------------------------------------------------------------
		# • Atualizar os objetos
		#----------------------------------------------------------------------
		def update
			super
			update_particle
			update_option
			update_active_skin
			update_continue
		end
		#----------------------------------------------------------------------
		# • Parte responsável por atualizar a partícula.
		#----------------------------------------------------------------------
		def update_particle
			Particle.update
			if @time_for_particle < 1
				Particle.smoke(TITLE[:PARTICLE][:POS])
				@time_for_particle = TITLE[:PARTICLE][:TIME_NEW]
			else
				@time_for_particle -= 1
			end
		end
		#----------------------------------------------------------------------
		# • Atualizar opções.
		#----------------------------------------------------------------------
		def update_option
			@option.each do |data|
				data.opacity += 5 unless data.opacity >= 255
				data.update
				if data.active
				  method(data.handler).call
				end
			end unless @option.empty?
		end
		#----------------------------------------------------------------------
		# • Ativar Skin
		#----------------------------------------------------------------------
		def update_active_skin
			if @active_skin
				@skin.visible = true
				Opacity.sprite_opacity_out(@skin, 4, 255)
				@skin.slide_left(4, @skin_pos.x)
			else
				Opacity.sprite_opacity_in(@skin, 25, 0)
				@skin.slide_right(4, @skin_pos.x + 64)
				@skin.visible = false if @skin.opacity <= 0
			end
		end
		#----------------------------------------------------------------------
		# • Atualizar continue
		#----------------------------------------------------------------------
		def update_continue
			if @continue_active
				@active_skin = true
				@window_savefile.active = true
				@window_savefile.visible = true
			else
				@active_skin = false
				@window_savefile.active = false
				@window_savefile.visible = false
			end
		end
		#----------------------------------------------------------------------
		# • new_game : Option
		#----------------------------------------------------------------------
		def new_game
			Particle.clear
      		DataManager.setup_new_game
      		fadeout_all
      		$game_map.autoplay
      		SceneManager.goto(Scene_Map)
		end
		#----------------------------------------------------------------------
		# • continue : Option
		#----------------------------------------------------------------------
		def continue
			return if !DataManager.save_file_exists?
			@window_savefile.refresh
			@continue_active = true
		end
		#----------------------------------------------------------------------
		# • shutdown : Option
		#----------------------------------------------------------------------
		def shutdown
			fadeout_all
			SceneManager.exit
		end
		#----------------------------------------------------------------------
		# • Confirmar load.
		#----------------------------------------------------------------------
		def load_on
			return unless DataManager.load_game(@window_savefile.index)
			Sound.play_load
			fadeout_all
			$game_system.on_after_load
            SceneManager.goto(Scene_Map)
		end
		#----------------------------------------------------------------------
		# • Cancelar load.
		#----------------------------------------------------------------------
		def load_cancel
			@continue_active = false
		end
		#----------------------------------------------------------------------
		# • Tocar a BGM da title.
		#----------------------------------------------------------------------
		def play_title_music
			$data_system.title_bgm.play
			RPG::BGS.stop
			RPG::ME.stop
		end
	end
}
