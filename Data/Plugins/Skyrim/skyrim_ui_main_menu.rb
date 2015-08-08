#==============================================================================
# • Skyrim UI : Main Menu
#==============================================================================
# Autor: Dax
# Versão: 1.0
# Site: www.dax-soft.weebly.com
# Requerimento: Dax Core
#==============================================================================
# • Descrição:
#------------------------------------------------------------------------------
#   Script do menu principal, do pacote Skyrim UI.
#==============================================================================
# • Versões:
#------------------------------------------------------------------------------
# 1.0 :
#   - Funções básicas.
#		- Item.
#		- Equipamentos.
#		- Habilidades.
#		- Status.
#		- Sistema.
#			- Salvar.
#			- Carregar.
#		  - Sair.
#==============================================================================
Dax.register(:skyrim_ui_main_menu, "dax", 1.0, [[:skyrim_ui, "dax", 3.0]]) {
	#==========================================================================
	# • Remover.
	#==========================================================================
	Dax.remove(:Scene_Menu)
	#==========================================================================
	# ** Window_MenuStatus
	#--------------------------------------------------------------------------
	#  Esta janela exibe os parâmetros dos membros do grupo na tela de menu.
	#==========================================================================
	class Window_MenuStatus < Window_Selectable
 		#----------------------------------------------------------------------
  	# * Inicialização do objeto
  	#----------------------------------------------------------------------
 	  def initialize(x, y)
    		super(x, y, window_width, window_height)
    		@pending_index = -1
    		self.opacity = 0
    		refresh
  	end
  	#----------------------------------------------------------------------
		# • Aquisição do número de colunas.
		#----------------------------------------------------------------------
 	  def col_max
    	return 2
  	end
  	#----------------------------------------------------------------------
  	# * Aquisição da largura da janela
  	#----------------------------------------------------------------------
  	def window_width
    		285 + (Graphics.width - 544)
 		end
 		#----------------------------------------------------------------------
  	# * Aquisição da altura da janela
  	#----------------------------------------------------------------------
  	def window_height
    		164 + (Graphics.height - 416)
  	end
  	#----------------------------------------------------------------------
  	# * Aquisição de altura do item
  	#----------------------------------------------------------------------
  	def item_height
    		(height - standard_padding * 2) / 2
  	end
  	#----------------------------------------------------------------------
  	# * Desenho de um item
  	#----------------------------------------------------------------------
  	def draw_item(index)
    		actor = $game_party.members[index]
    		enabled = $game_party.battle_members.include?(actor)
    		rect = item_rect(index)
    		draw_item_background(index)
    		draw_actor_face(actor, rect.x + 1, rect.y + 1, enabled)
  	end
  	#----------------------------------------------------------------------
		# • Desenhar face do ator, de maneira específica.
		#----------------------------------------------------------------------
  		def draw_actor_face(user, x, y, enabled)
    		bitmap = Cache.face(user.face_name)
   			_rect = Rect.new(x, y, 64, 64)
    		rect = Rect.new(user.face_index % 4 * 96, user.face_index / 4 * 96, 96, 96)
    		contents.stretch_blt(_rect, bitmap, rect, enabled ? 255 : translucent_alpha)
    		bitmap.dispose
  		end
	end
	#==========================================================================
	# • Window_Help
	#==========================================================================
	class Window_Help < Window_Base
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		alias :skyrim_ui_init_help :initialize
		def initialize(*args, &block)
			skyrim_ui_init_help(*args, &block)
			self.opacity = 0
		end
	end
	#==========================================================================
	# • Window_ItemList
	#==========================================================================
	class Window_ItemList < Window_Selectable
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		alias :skyrim_ui_init_itemlist :initialize
		def initialize(*args, &block)
			skyrim_ui_init_itemlist(*args, &block)
			self.opacity = 0
		end
		#----------------------------------------------------------------------
		# • Aquisição da coluna.
		#----------------------------------------------------------------------
		def col_max
			return 1
		end
	end
	#==========================================================================
	# • Window_SkillList
	#==========================================================================
	class Window_SkillList < Window_Selectable
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		alias :skyrim_ui_init_skilllist :initialize
		def initialize(*args, &block)
			skyrim_ui_init_skilllist(*args, &block)
			self.opacity = 0
		end
		#----------------------------------------------------------------------
		# • Aquisição da coluna.
		#----------------------------------------------------------------------
		def col_max
			return 1
		end
	end
	#==========================================================================
	# • Window_EquipStatus
	#==========================================================================
	class Window_EquipStatus < Window_Base
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		alias :skyrim_ui_init_equipstatus :initialize
		def initialize(*args, &block)
			skyrim_ui_init_equipstatus(*args, &block)
			self.opacity = 0
		end
		#----------------------------------------------------------------------
		# • Mudar tamanho da janela. <width>
		#----------------------------------------------------------------------
		def window_width
			285 + (Graphics.width - 544)
		end
		#----------------------------------------------------------------------
		# • Mudar tamanho da janela. <height>
		#----------------------------------------------------------------------
		def window_height
			164 + (Graphics.height - 416)
		end
	end
	#==========================================================================
	# • Window_EquipSlot
	#==========================================================================
	class Window_EquipSlot < Window_Selectable
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		alias :skyrim_ui_init_equipslot :initialize
		def initialize(*args, &block)
			skyrim_ui_init_equipslot(*args, &block)
			self.opacity = 0
		end
		#----------------------------------------------------------------------
		# • Mudar número de colunas.
		#----------------------------------------------------------------------
		def col_max
			return 1
		end
		#----------------------------------------------------------------------
		# • Número de linhas a serem exibidas.
		#----------------------------------------------------------------------
		def visible_line_number
			return 5
		end
	end
	#==========================================================================
	# • Window_GameEnd
	#==========================================================================
	class Window_GameEnd < Window_Command
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		alias :skyrim_ui_init_gameend :initialize
		def initialize(*args, &block)
			skyrim_ui_init_gameend(*args, &block)
			self.opacity = 0
		end
	end
	#==========================================================================
	# • Scene_Menu : Skyrim
	#==========================================================================
	class Scene_Menu < Scene_MenuBase
		#----------------------------------------------------------------------
		# • Incluir.
		#----------------------------------------------------------------------
		include Skyrim
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		def start
			super
			setup
			create_actor_window
			create_skin
			create_option
			create_gold
			create_namemap
			create_ministatus
			create_status
			create_option_item
			create_option_skill
			create_window_skill
			create_option_equip
			create_window_equip
			create_option_system
			create_window_end
			create_window_savelist
			create_window_loadlist
			@help_window = Window_Help.new
   		@help_window.viewport = @viewport
			@help_window.y = @skin_info.y - (@help_window.height + 4) + 12
			@layout_item = Sprite.new
			@layout_item.opacity = 0
			@layout_item.bitmap = Cache.skyrim(GRAPHIC[:LAYOUTITEM])
		end
		#----------------------------------------------------------------------
		# • Configurar as variáveis.
		#----------------------------------------------------------------------
		def setup
			@option	= []
			@option_item = []
			@option_skill = []
			@option_equip = []
			@option_system = []
			@index = 0
			@exit = true
			@active_item = false
			@active_skill = false
			@active_equip = false
			@active_slot_equip = false
			@active_system = false
			@active_window_system = false
			@category_item = :item
			@option_id_enable = -1
			@stype_id_option = 1
			@slot_item_index = 1
		end
		#----------------------------------------------------------------------
		# • Todas as chaves de ativar.
		#----------------------------------------------------------------------
		def all_active_var(value=false)
			[@active_item, @active_skill, @active_equip, @active_system].each { |_active| _active = value }
		end
		#----------------------------------------------------------------------
		# • Ator atual.
		#----------------------------------------------------------------------
		def user
			@index = @actor_window.visible ? @actor_window.index : @index if defined?(@actor_window)
			$game_party.members[@index % $game_party.members.size]
		end
		#----------------------------------------------------------------------
		# • Criar as Skin.
		#----------------------------------------------------------------------
		def create_skin
			@skin_option = SkinUI.new(-2, Graphics.width+4, 64, true)
			@skin_option.angle!
			@skin_info = SkinUI.new(-2, Graphics.width+4, 64, true)
			@skin_info.position(3)
		end
		#----------------------------------------------------------------------
		# • Criar as opções.
		#----------------------------------------------------------------------
		def create_option
			MAIN_MENU[:OPTION].each_with_index do |data, n|
				_x_pos_ = ( (Graphics.width - (100 * MAIN_MENU[:OPTION].size)) / 2 ) - 10
				_pos = Position.new( _x_pos_ + (110 * n) ,  24)
				@option[n] = Button.new(_pos, data.get(:title), :BUTTON, 1, 100)
				@option[n].handler = data.get(:handler)
				@option[n].use = eval(data.get(:enable)) if data.get(:enable)
			end
		end
		#----------------------------------------------------------------------
		# • Criar a info. do dinheiro.
		#----------------------------------------------------------------------
		def create_gold
			@goldtext = Sprite_Text.new(8, 0, 48, 24, "")
    		@goldtext.y = DMath.centralize_object(@skin_info, @goldtext)[1]
    		@goldtext.opacity = 127
    		@gold = Sprite_Text.new(52, 0, 96, 24, "")
    		@gold.y = @goldtext.y
			@goldtext.z = @gold.z = @skin_info.z + 2
	    end
		#----------------------------------------------------------------------
		# • Criar o nome do mapa.
		#----------------------------------------------------------------------
		def create_namemap
			@namemap = Sprite.new([Graphics.width-4, 24, 4, 0, @skin_option.z.next])
			Skyrim.bit_font[@namemap, :SUB]
			@namemap.bitmap.draw_text_rect($game_map.display_name.to_s, 1)
		end
		#----------------------------------------------------------------------
		# • Criar ministatus.
		#----------------------------------------------------------------------
		def create_ministatus
			@face = Sprite.new([60, 60, 0, 0, @skin_info.z.next])
			@face.position(5)
			@face.x -= 48
			bar_ministatus
			_pos = Position.new(@bar_hp.x - 28, Graphics.height - 32)
			@status_icon = Status_Icon.new(user, _pos, @face.z)
			refresh_ministatus
			cursor_ministatus
			_pos = Position.new(_pos.x, _pos.y - 28)
			@more_ministatus = Button.new(_pos, "+", :BUTTON, 1, 24, 24)
			@more_ministatus.handler = :window_status_active
		end
		#----------------------------------------------------------------------
		# • Criar as barras.
		#----------------------------------------------------------------------
		def bar_ministatus
			@bar_hp = Bar.new(:HPBAR, user.hp, user.mhp, (@face.x - 24) - 100, @face.y+4)
			@bar_mp = Bar.new(:SKILLBAR, user.hp, user.mmp, @bar_hp.x, @bar_hp.y + (4 + @bar_hp.height))
			_current_xp = user.exp - user.current_level_exp
			_max_xp = user.next_level_exp.to_f - user.current_level_exp.to_f
			@bar_xp = Bar.new(:XPBAR, _current_xp, _max_xp, @bar_mp.x, @bar_mp.y + (4 + @bar_mp.height))
			@bar_hp.z = @bar_mp.z = @bar_xp.z = @face.z
		end
		#----------------------------------------------------------------------
		# • Cursores para mudar de ator.
		#----------------------------------------------------------------------
		def cursor_ministatus
			return if $game_party.members.size == 1
			@ministatus_next = Cursor.new(0, 0, true, @skin_info.z.next)
			@ministatus_next.position(5)
			@ministatus_next.y = DMath.centralize_object(@skin_info, @ministatus_next)[1]
			@ministatus_next.x -= 4
			@ministatus_next.opacity = 127
			@ministatus_pred = Cursor.new(0, 0, false, @skin_info.z.next)
			@ministatus_pred.position(5)
			@ministatus_pred.y = DMath.centralize_object(@skin_info, @ministatus_next)[1]
			@ministatus_pred.x -= (@bar_hp.x - 36)
			@ministatus_pred.opacity = 127
		end
		#----------------------------------------------------------------------
		# • Criar status.
		#----------------------------------------------------------------------
		def create_status
			@sprite_status = Sprite_Status.new
			@sprite_status.user = user
			@sprite_status.visible = false
		end
		#----------------------------------------------------------------------
		# • Criar as opções dos itens.
		#----------------------------------------------------------------------
		def create_option_item
			ITEM[:OPTION].each_with_index do |data, n|
				_x_pos = ( (Graphics.width - (100 * ITEM[:OPTION].size)) / 2 ) - 10
				_pos = Position.new(_x_pos + (110 * n), 72)
				@option_item[n] = Button.new(_pos, data.get(:title), :BUTTON, 1, 100)
				@option_item[n].handler = data.get(:handler)
				@option_item[n].visible = false
			end
			_width = 208
			_height = Graphics.height - 256
			@window_itemlist = Window_ItemList.new(32, 128, _width, _height)
			@window_itemlist.position(:center_left)
			@window_itemlist.x += 32
			@window_itemlist.visible = false
			@window_itemlist.active = false
			@window_itemlist.viewport = @viewport
			@window_itemlist.set_handler(:ok, method(:on_item_ok))
		end
		#----------------------------------------------------------------------
		# • Criar as janelas das habilidades
		#----------------------------------------------------------------------
		def create_window_skill
			@window_skill = Window_SkillList.new(32, 128, 208, Graphics.height - 256)
			@window_skill.position(:center_left)
			@window_skill.x += 32
			@window_skill.visible = false
			@window_skill.active = false
			@window_skill.viewport = @viewport
			@window_skill.set_handler(:ok, method(:on_skill_ok))
		end
		#----------------------------------------------------------------------
		# • Criar as opções das habilidades.
		#----------------------------------------------------------------------
		def create_option_skill
			user.added_skill_types.sort.each_with_index do |stype_id, n|
					_name = $data_system.skill_types[stype_id]
					_x_pos = ( (Graphics.width - (110 * user.added_skill_types.sort.size) ) / 2) - 10
					_pos = Position.new(_x_pos + (120 * n), 72)
					@option_skill[n] = Button.new(_pos, _name, :BUTTON, 1, 110)
					@option_skill[n].handler = :skill
					@option_skill[n].visible = false
					@option_skill[n].index = n.next
			end
		end
		#----------------------------------------------------------------------
		# • refresh das opções das habilidades
		#----------------------------------------------------------------------
		def refresh_option_skill
			@option_skill.each_with_index do |data, index|
				data.dispose
				@option_skill.delete_at(index)
			end.clear unless @option_skill.nil?
			create_option_skill
		end
		#----------------------------------------------------------------------
		# • Criar janela do ator.
		#----------------------------------------------------------------------
		def create_actor_window
			@actor_window = Window_MenuActor.new
			@actor_window.position(:center_right)
			@actor_window.set_handler(:ok, method(:on_actor_ok))
			@actor_window.set_handler(:cancel, method(:on_actor_cancel))
		end
		#----------------------------------------------------------------------
  		# * Exibição da sub-janela
  		#----------------------------------------------------------------------
  		def show_sub_window(window)
    		width_remain = Graphics.width - window.width
    		window.x = width_remain
    		window.show.activate
  		end
 		#----------------------------------------------------------------------
  	# * Ocultação da sub-janela
  	#----------------------------------------------------------------------
  	def hide_sub_window(window)
    		window.hide.deactivate
    		@window_itemlist.refresh
			@window_itemlist.activate
  	end
		#----------------------------------------------------------------------
		# • Criar as opções dos equipamento.
		#----------------------------------------------------------------------
		def create_option_equip
			EQUIP[:OPTION].each_with_index do |data, n|
				_x_pos = ( (Graphics.width - (100 * EQUIP[:OPTION].size)) / 2 ) - 10
				_pos = Position.new(_x_pos + (110 * n), 72)
				@option_equip[n] = Button.new(_pos, data.get(:title), :BUTTON, 1, 100)
				@option_equip[n].handler = data.get(:handler)
				@option_equip[n].visible = false
				@option_equip[n].index = n.next
			end
		end
		#----------------------------------------------------------------------
		# • Criar janelas do equipamento.
		#----------------------------------------------------------------------
		def create_window_equip
			@status_equip =  Window_EquipStatus.new(0, 0)
			@status_equip.position(:center_right)
    	@status_equip.viewport = @viewport
    	@status_equip.actor = user
			@status_equip.visible = false

			@equip_slot = Window_EquipSlot.new(32, 128, 240)
			@equip_slot.position(:center_left)
			@equip_slot.viewport = @viewport
			@equip_slot.status_window = @status_equip
			@equip_slot.actor = user
			@equip_slot.set_handler(:ok,	method(:on_equip_ok))
			@equip_slot.visible = false
			@equip_slot.active = false

			@equip_itemlist = Window_EquipItem.new(0, 0, 240, 164 + (Graphics.height - 416))
			@equip_itemlist.position(:center_left)
			@equip_itemlist.viewport = @viewport
			@equip_itemlist.actor = user
			@equip_itemlist.set_handler(:ok, 				method(:change_equip_ok))
			@equip_itemlist.set_handler(:cancel,    method(:change_equip_cancel))
			@equip_slot.item_window = @equip_itemlist
			@equip_itemlist.visible = false
			@equip_itemlist.active = false
		end
		#----------------------------------------------------------------------
		# • Criar as opções do sistema.
		#----------------------------------------------------------------------
		def create_option_system
			@skin_system = SkinUI.new([-64, 0], 164, Graphics.height)
			@skin_system.visible = false
			@skin_system.z = @skin_info.z + 10
			@skin_system.opacity = 0

			MAIN_MENU[:SYSTEM_OPTION].each_with_index do |data, n|
				_y_pos = ( (Graphics.height - (24 * MAIN_MENU[:SYSTEM_OPTION].size)) / 2 ) - 10
				_pos = Position.new(0, _y_pos + (32 * n))
				@option_system[n] = Button.new(_pos, data.get(:title), :BUTTON, 1, 164, 24)
				@option_system[n].handler = data.get(:handler)
				@option_system[n].use = eval(data.get(:enable)) if data.get(:enable)
				@option_system[n].visible = false
			end

			@window_system = Sprite.new()
			@window_system.bitmap = Cache.skyrim(GRAPHIC[:MENU][:WINDOW])
			@window_system.visible = false
			@window_system.opacity = 0
			@window_system.position(:center_right)

		end
		#----------------------------------------------------------------------
		# • create_window_end
		#----------------------------------------------------------------------
		def create_window_end
			@window_end = Window_GameEnd.new
			@window_end.set_handler(:to_title, method(:command_to_title))
			@window_end.set_handler(:shutdown, method(:shutdown))
			@window_end.set_handler(:cancel,   method(:return_to_system))
			@window_end.visible = false
			@window_end.active = false
		end
		#----------------------------------------------------------------------
		# • create_window_savelist
		#----------------------------------------------------------------------
		def create_window_savelist
			@window_savelist = Window_SaveList.new(0, 0, 160, 128)
			@window_savelist.visible = false
			@window_savelist.active = false
			@window_savelist.set_handler(:ok,		method(:on_save))
			@window_savelist.set_handler(:cancel, method(:cancel_save))
		end
		#----------------------------------------------------------------------
		# • create_window_loadlist
		#----------------------------------------------------------------------
		def create_window_loadlist
			@window_loadlist = Window_LoadList.new(0, 0, 160, 128)
			@window_loadlist.visible = false
			@window_loadlist.active = false
			@window_loadlist.set_handler(:ok,		method(:on_load))
			@window_loadlist.set_handler(:cancel, method(:cancel_load))
	  end
		#----------------------------------------------------------------------
		# • Deletar os objetos.
		#----------------------------------------------------------------------
		def terminate
			super
		  [@ministatus_next, @ministatus_pred, @skin_option, @skin_info, @goldtext, @gold, @namemap, @face,
			@bar_hp, @bar_mp, @bar_xp, @status_icon, @more_ministatus,
			@sprite_status, @layout_item, @skin_system, @window_system,
			@option, @option_item, @option_skill, @option_equip, @option_system].each do |data|
				next if data.nil?
				if data.is_a?(Array)
					data.each { |__data__|
						next if __data__.nil?
						__data__.dispose
					}
				else
					data.dispose
				end
			end
		end
		#----------------------------------------------------------------------
		# • Atualizar os objetos.
		#----------------------------------------------------------------------
		def update
			super
			return_scene_key if @exit
			[@bar_hp, @bar_mp, @bar_xp].each(&:update) if Graphics.frame_rate % 5 == 0
			update_bar
			@status_icon.update
			if @active_item or @active_skill or @active_equip
				Opacity.sprite_opacity_out(@layout_item, 5, 255)
			else
				Opacity.sprite_opacity_in(@layout_item, 10, 0)
			end
			update_option
			update_option_item
			update_option_skill
			update_option_equip
			update_option_system
			update_gold
			update_cursor_ministatus
			update_more_ministatus
			update_status
			if @actor_window.active and @index != @actor_window.index
				@index = @actor_window.index
				action_ministatus
			end
			@help_window.set_item(@window_itemlist.item) if @active_item
			@help_window.set_item(@window_skill.item) if @active_skill
			@help_window.set_item(@equip_itemlist.item) if @active_equip && (@active_slot_equip or @equip_itemlist.active)
		end
		#----------------------------------------------------------------------
		# • Atualizar barras.
		#----------------------------------------------------------------------
		def update_bar
			return unless user.is_a?(Game_Actor)
			@bar_hp.current = user.hp
			@bar_hp.current_max = user.mhp
			@bar_mp.current = user.mp
			@bar_mp.current_max = user.mmp
			@bar_xp.current = user.exp - user.current_level_exp
			@bar_xp.current_max = user.next_level_exp.to_f - user.current_level_exp.to_f
		end
		#----------------------------------------------------------------------
		# • Atualizar as opções.
		#----------------------------------------------------------------------
		def update_option
			@option.each_with_index do |data, n|
				next if @active_item or @active_skill or @active_equip or @active_system
				data.update
				if data.active
					@help_window.clear
					method(data.handler).call
				end
			end
		end
		#----------------------------------------------------------------------
		# • Atualizar as opções da categoria dos item.
		#----------------------------------------------------------------------
		def update_option_item
			trigger?(0x02) {
				@active_item = false
				@help_window.visible = false
				@exit = true
			} if @active_item
			@option_item.each do |data|
				data.visible = @active_item
				data.update
				if data.active
					method(data.handler).call
					@window_itemlist.category = @category_item
					@window_itemlist.refresh
				end
			end
			@window_itemlist.visible =  @active_item
			_rect = @window_itemlist
			@window_itemlist.active =  Mouse.area?(_rect.x, _rect.y, _rect.width, _rect.height) && @window_itemlist.visible
			@window_itemlist.active = false if @actor_window.visible
		end
		#----------------------------------------------------------------------
		# • Atualização das opções da categoria de habilidade
		#----------------------------------------------------------------------
		def update_option_skill
			trigger?(0x02) {
				@active_skill = false
				@help_window.visible = false
				@exit = true
			} if @active_skill
			@option_skill.each { |data|
					data.visible = @active_skill
					data.update
					if data.active
						@stype_id_option = data.index
						method(data.handler).call
					end
			} unless @option_skill.empty?
			@window_skill.actor = user if @active_skill && @window_skill.active
			@window_skill.visible = @active_skill
			_rect = @window_skill
			@window_skill.active =  Mouse.area?(_rect.x, _rect.y, _rect.width, _rect.height) && @window_skill.visible
			@window_skill.active = false if @actor_window.visible
		end
		#----------------------------------------------------------------------
		# • Atualização das opções da categoria equipamento.
		#----------------------------------------------------------------------
		def update_option_equip
			trigger?(0x02) {
				@active_equip = false
				@active_slot_equip = false
				@help_window.visible = false
				@exit = true
			} if @active_equip
			@option_equip.each { |data|
					data.visible = @active_equip
					data.update
					if data.active
						@slot_item_index = data.index
						method(data.handler).call
					end
			} unless @option_skill.empty?

			@status_equip.visible = @active_equip
			@status_equip.actor = user

			@equip_slot.visible = @active_slot_equip
			@equip_slot.actor = user
			_rect = 	@equip_slot
			@equip_slot.active =  Mouse.area?(_rect.x, _rect.y, _rect.width, _rect.height) && @equip_slot.visible

			if @equip_itemlist.visible
				@equip_itemlist.actor = user
				_rect2 = @equip_itemlist
				@equip_itemlist.active = Mouse.area?(_rect2.x, _rect2.y, _rect2.width, _rect2.height)
			end
		end
		#----------------------------------------------------------------------
		# • Atualizar as opções do sistema.
		#----------------------------------------------------------------------
		def update_option_system
			unless @active_window_system
				trigger?(0x02) {
					@active_system = false
					@exit = true
					} if @active_system
			else
				trigger?(0x02) {
						@active_window_system = false
						@window_end.visible = false
						@window_savelist.visible = false
						@window_loadlist.visible = false
				 }
			end
			@option_system.each_with_index { |data, n|
				_enable = eval(MAIN_MENU[:SYSTEM_OPTION][n].get(:enable)) if MAIN_MENU[:SYSTEM_OPTION][n].get(:enable)
				data.visible = @active_system
				data.use = !_enable
				data.update
				method(data.handler).call if data.active
			}
			if @active_system
				@skin_system.visible = true
				Opacity.sprite_opacity_out(@skin_system, 5, 255)
				@skin_system.slide_right(4, 0)
			else
				@skin_system.visible = false if @skin_system.opacity <= 0
				Opacity.sprite_opacity_in(@skin_system, 5, 0)
				@skin_system.slide_left(2, -64)
			end
			if @active_window_system
				@window_system.visible = true
				Opacity.sprite_opacity_out(@window_system, 5, 255)
				_adpx =  Graphics.width > 544 ? (Graphics.width - 544) : 0
				@window_system.slide_left(4, Graphics.width - (@window_system.width + (@window_system.width / 3)) - _adpx )
			else
				@window_system.visible = false if @window_system.opacity <= 0
				Opacity.sprite_opacity_in(@window_system, 5, 0)
				@window_system.slide_right(4, Graphics.width)
			end
			if @window_end.visible
				@window_end.x, @window_end.y = *DMath.centralize_object(@window_system, @window_end)
				_rect_end = Rect.new(@window_end.x, @window_end.y, @window_end.width, @window_end.height)
				@window_end.active = Mouse.area?(*_rect_end.to_a)
			elsif @window_savelist.visible
				@window_savelist.x, @window_savelist.y = *DMath.centralize_object(@window_system, @window_savelist)
				_rect_end = Rect.new(@window_savelist.x, @window_savelist.y, @window_savelist.width, @window_savelist.height)
				@window_savelist.active = Mouse.area?(*_rect_end.to_a)
			elsif @window_loadlist.visible
				@window_loadlist.x, @window_loadlist.y = *DMath.centralize_object(@window_system, @window_loadlist)
				_rect_end = Rect.new(@window_loadlist.x, @window_loadlist.y, @window_loadlist.width, @window_loadlist.height)
				@window_loadlist.active = Mouse.area?(*_rect_end.to_a)
			end
		end
		#----------------------------------------------------------------------
		# • Atualizar a info. do dinheiro.
		#----------------------------------------------------------------------
		def update_gold
			[@goldtext, @gold].each(&:update)
			Skyrim.bit_font[@goldtext, :BUTTON]
			Skyrim.bit_font[@gold,	   :SUB]
			@gold.text	=	String($game_party.gold)
			@goldtext.text = MAIN_MENU[:TEXT][:GOLD]
		end
		#----------------------------------------------------------------------
		# • Atualizar os cursores do ministauts
		#----------------------------------------------------------------------
		def update_cursor_ministatus
			return if $game_party.members.size == 1
			[@ministatus_next, @ministatus_pred].each{ |i|
				i.if_mouse_over { |over| i.opacity = over ? 255 : 127 }
			}
			@ministatus_next.if_mouse_click {
				@index += 1
				action_ministatus
			}
			@ministatus_pred.if_mouse_click {
				@index -= 1
				action_ministatus
			}
		end
		#----------------------------------------------------------------------
		# • Ministatus.
		#----------------------------------------------------------------------
		def action_ministatus
			refresh_ministatus
			if @active_skill
				@option_skill.each {|i| i.opacity = 0}
				refresh_option_skill
			end
		end
		#----------------------------------------------------------------------
		# • Atualizar o botão de mais status
		#----------------------------------------------------------------------
		def update_more_ministatus
			@more_ministatus.update
			if @more_ministatus.active
				method(@more_ministatus.handler).call
			end
		end
		#----------------------------------------------------------------------
		# • Atualizar status.
		#----------------------------------------------------------------------
		def update_status
			@sprite_status.update
			if @sprite_status.visible && !@exit
				trigger?(0x02) {
					@sprite_status.visible = false
					@exit = true
				}
			end
		end
		#----------------------------------------------------------------------
		# • Menu do item.
		#----------------------------------------------------------------------
		def menu_item
			return if @sprite_status.visible
			@help_window.visible = true
			@window_itemlist.category = @category_item
			@window_itemlist.refresh
			all_active_var
			@active_item = true
			@exit = false
		end
		#----------------------------------------------------------------------
		# • Menu da habilidade.
		#----------------------------------------------------------------------
		def menu_skill
			return if @sprite_status.visible
			@help_window.visible = true
			all_active_var
			@active_skill = true
			@exit = false
		end
		#----------------------------------------------------------------------
		# • Menu do equipamento.
		#----------------------------------------------------------------------
		def menu_equip
			return if @sprite_status.visible
			@help_window.visible = true
			all_active_var
			@active_equip = true
			@exit = false
		end
		#----------------------------------------------------------------------
		# • Menu do sistema.
		#----------------------------------------------------------------------
		def menu_system
			return if @sprite_status.visible
			all_active_var
			@active_system = true
			@exit = false
		end
		#----------------------------------------------------------------------
		# • Ativar janela de status
		#----------------------------------------------------------------------
		def window_status_active
			return if @active_item
			@sprite_status.visible = !@sprite_status.visible
			@sprite_status.user = user
			@sprite_status.refresh
			@exit = !@sprite_status.visible
		end
		#----------------------------------------------------------------------
		# • Categoria item.
		#----------------------------------------------------------------------
		def category_item
			@category_item = :item
		end
		#----------------------------------------------------------------------
		# • Categoria armas.
		#----------------------------------------------------------------------
		def category_weapon
			@category_item = :weapon
		end
		#----------------------------------------------------------------------
		# • Categoria armadura.
		#----------------------------------------------------------------------
		def category_armor
			@category_item = :armor
		end
		#----------------------------------------------------------------------
		# • Categoria chave.
		#----------------------------------------------------------------------
		def category_key
			@category_item = :key_item
		end
		#----------------------------------------------------------------------
		# • On Item Ok
		#----------------------------------------------------------------------
		def on_item_ok
			$game_party.last_item.object = item
    	determine_item
		end
		#--------------------------------------------------------------------------
  	# * Aquisição das informações do item selecionado
  	#--------------------------------------------------------------------------
  	def item
    	return @window_itemlist.item if @active_item
			return @window_skill.item if @active_skill
			@window_itemlist.item
 		end
		#----------------------------------------------------------------------
  		# * Herói [Confirmação]
 		#----------------------------------------------------------------------
  		def on_actor_ok
    		if item_usable?
      		use_item
    		else
     		 	Sound.play_buzzer
    		end
  		end
  		#----------------------------------------------------------------------
  		# * Herói [Cancelamento]
  		#----------------------------------------------------------------------
  		def on_actor_cancel
    		hide_sub_window(@actor_window)
  		end
		#----------------------------------------------------------------------
  		# * Definição do item
  		#----------------------------------------------------------------------
  		def determine_item
    		if item.for_friend?
      			show_sub_window(@actor_window)
      			@actor_window.select_for_item(item)
    		else
      			use_item
						@window_itemlist.activate
    		end
  		end
		#----------------------------------------------------------------------
  		# * Aquisição da lista de heróis válidos como alvos do item
  		#----------------------------------------------------------------------
  		def item_target_actors
    		if !item.for_friend?
     			 []
    		elsif item.for_all?
      			$game_party.members
    		else
      			[$game_party.members[@actor_window.index]]
    		end
  		end
  		#----------------------------------------------------------------------
  		# * Definição de itens disponíveis para uso
  		#----------------------------------------------------------------------
  		def item_usable?
    		user.usable?(item) && item_effects_valid?
  		end
  		#----------------------------------------------------------------------
  		# * Definição de efeitos válidos do item
  		#----------------------------------------------------------------------
  		def item_effects_valid?
    		item_target_actors.any? do |target|
      			target.item_test(user, item)
    		end
  		end
  		#----------------------------------------------------------------------
  		# * Itens utilizados para os heróis
  		#----------------------------------------------------------------------
  		def use_item_to_actors
    		item_target_actors.each do |target|
      			item.repeats.times { target.item_apply(user, item) }
    		end
  		end
  	#----------------------------------------------------------------------
  	# * Usando um item
  	#----------------------------------------------------------------------
  	def use_item
    	Sound.play_use_item if @active_item
			Sound.play_use_skill if @active_skill
    	user.use_item(item)
    	use_item_to_actors
			update_bar
			@window_itemlist.refresh if @active_item
			@window_skill.refresh if @active_skill
    	check_common_event
    	check_gameover
			refresh_ministatus
    	@actor_window.refresh
  	end
		#----------------------------------------------------------------------
		# • Ativar on_skill_ok
		#----------------------------------------------------------------------
		def on_skill_ok
			user.last_skill.object = item
			determine_item
		end
		#----------------------------------------------------------------------
		# • Handler :skill
		#----------------------------------------------------------------------
		def skill
			@window_skill.stype_id = @stype_id_option
			@window_skill.refresh
			@window_skill.activate
		end
		#----------------------------------------------------------------------
		# • Mudar equipamento.
		#----------------------------------------------------------------------
		def change_equip
			@active_slot_equip = true
		end
		#----------------------------------------------------------------------
		# • Optimizar equipamento
		#----------------------------------------------------------------------
		def optimize_equip
			Sound.play_equip
			user.optimize_equipments
			refresh_ministatus
			@equip_slot.refresh
			@status_equip.refresh
		end
		#----------------------------------------------------------------------
		# • Remover tudo.
		#----------------------------------------------------------------------
		def remove_equip
			Sound.play_equip
			user.clear_equipments
			@status_equip.refresh
			@equip_slot.refresh
		end
		#----------------------------------------------------------------------
		# • Confirmar equipamento
		#----------------------------------------------------------------------
		def on_equip_ok
			@active_slot_equip = false
			@equip_itemlist.visible = true
			@equip_itemlist.activate
		end
		#----------------------------------------------------------------------
		# • Mudar equipamento.
		#----------------------------------------------------------------------
		def change_equip_ok
			Sound.play_equip
			user.change_equip(@equip_slot.index, @equip_itemlist.item)
			@equip_itemlist.refresh
			@equip_itemlist.visible = false
			@equip_itemlist.active = false
			@equip_slot.refresh
			@status_equip.refresh
			@active_slot_equip = true
		end
		#----------------------------------------------------------------------
		# • Cancelar mudança de equipamento.
		#----------------------------------------------------------------------
		def change_equip_cancel
			@equip_itemlist.visible = false
			@equip_itemlist.active = false
			@equip_slot.refresh
			@active_slot_equip = true
		end
		#----------------------------------------------------------------------
		# • :menu_save
		#----------------------------------------------------------------------
		def menu_save
			return if @window_savelist.visible or @window_loadlist.visible or @window_end.visible
			@active_window_system = true
			@window_savelist.refresh
			@window_savelist.visible = true
			@window_savelist.active = true
		end
		#----------------------------------------------------------------------
		# • :menu_load
		#----------------------------------------------------------------------
		def menu_load
			return if @window_savelist.visible or @window_loadlist.visible or @window_end.visible
			@active_window_system = true
			@window_loadlist.refresh
			@window_loadlist.visible = true
			@window_loadlist.active = true
		end
		#----------------------------------------------------------------------
		# • :menu_quit
		#----------------------------------------------------------------------
		def menu_quit
			return if @window_savelist.visible or @window_loadlist.visible or @window_end.visible
			@active_window_system = true
			@window_end.visible = true
			@window_end.active = true
		end
		#----------------------------------------------------------------------
		# • Comando para ir direto para title.
		#----------------------------------------------------------------------
		def command_to_title
			@window_end.close
			fadeout_all
    	SceneManager.goto(Scene_Title)
		end
		#----------------------------------------------------------------------
		# • Comando para sair do jogo direto.
		#----------------------------------------------------------------------
		def shutdown
			@window_end.close
			fadeout_all
    	SceneManager.exit
		end
		#----------------------------------------------------------------------
		# • Comando para retornar ao sistema.
		#----------------------------------------------------------------------
		def return_to_system
			@active_window_system = false
			@window_end.visible = false
			@window_end.active = false
		end
		#----------------------------------------------------------------------
		# • on_save
		#----------------------------------------------------------------------
		def on_save
			return unless DataManager.save_game(@window_savelist.index)
			Sound.play_save
			cancel_save
		end
		#----------------------------------------------------------------------
		# • cancel_save
		#----------------------------------------------------------------------
		def cancel_save
			@active_window_system = false
			@window_savelist.visible = false
			@window_savelist.active = false
		end
		#----------------------------------------------------------------------
		# • on_load
		#----------------------------------------------------------------------
		def on_load
			return unless DataManager.load_game(@window_loadlist.index)
			Sound.play_load
			fadeout_all
			$game_system.on_after_load
      SceneManager.goto(Scene_Map)
		end
		#----------------------------------------------------------------------
		# • cancel_load
		#----------------------------------------------------------------------
		def cancel_load
			@active_window_system = false
			@window_loadlist.visible = false
			@window_loadlist.active = false
		end
  	#----------------------------------------------------------------------
  	# * Definição de reserva de evento comun.
  	#    Transição para tela do mapa se a chamada è reservada para o evento
  	#----------------------------------------------------------------------
  	def check_common_event
     	SceneManager.goto(Scene_Map) if $game_temp.common_event_reserved?
  	end
		#----------------------------------------------------------------------
		# • Refrest do ministatus.
		#----------------------------------------------------------------------
		def refresh_ministatus
			@status_icon.user = user
			@face.bitmap.clear
			_bitmap = Cache.face(user.face_name)
			rect = Rect.new(user.face_index % 4 * 96, user.face_index / 4 * 96, 96, 96)
			@face.bitmap.stretch_blt(@face.rect, _bitmap, rect)
			_bitmap.dispose
			if defined?(@sprite_status)
				@sprite_status.user = user
				@sprite_status.refresh
			end
		end
	end
	#==========================================================================
	# • Game_Party
	#==========================================================================
	class Game_Party < Game_Unit
  		#----------------------------------------------------------------------
  		# * Aquisição do valor máximo de dinheiro
  		#----------------------------------------------------------------------
  		def max_gold
    		return Skyrim::LIMIT_GOLD
  		end
	end
	#==========================================================================
	# • Scene_Map
	#==========================================================================
	class Scene_Map < Scene_Base
  		#----------------------------------------------------------------------
  		# * Atualização da chamada do menu quando pressionada tecla
  		#----------------------------------------------------------------------
  		def update_call_menu
    		if $game_system.menu_disabled || $game_map.interpreter.running?
      			@menu_calling = false
    		else
      			@menu_calling ||= Input.trigger?(:B) || trigger?(0x02)
      			call_menu if @menu_calling && !$game_player.moving?
    		end
  		end
	end
}
