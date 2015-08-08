#==============================================================================
# • Skyrim UI Menu
#==============================================================================
# Autor: Dax
# Versão: 3.0
# Site: www.dax-soft.weebly.com
# Requerimento: Dax Core
#==============================================================================
# • Descrição:
#------------------------------------------------------------------------------
#   Pacote de scripts que trazem um pouco da interface de Skyrim para seu jogo.
#  -> Os arquivos gráficos devem estar na pasta Skyrim, dentro da Graphics.
#==============================================================================
# • Versões:
#------------------------------------------------------------------------------
# 1.0 :
#   - Screen Title.
#   - Menu principal.
# 1.5 :
#   - Menu principal : Menu de sair.
#   - Menu principal : Layout de fundo.
#   - Menu principal : Menu de status.
#   - Menu principal : Menu de carregar.
#   - Menu principal : Menu de salvar.
# 2.0 :
#   - Menu principal : Menu de itens.
#   - Menu principal : Menu de habilidades.
# 2.5 :
#   - Menu principal : Menu de equipamentos.
# 3.0 :
#   - Melhorias no sistema.
#   - Novo Design.
#==============================================================================
Dax.register(:skyrim_ui, "dax", 3.0) {
	#==========================================================================
	# • Configuração Geral da Fonte.
	#==========================================================================
	Font.default_name = "Futura MdCn BT"
    Font.default_size = 18
    Font.default_bold = false
    Font.default_italic = false
    Font.default_outline = false
    Font.default_out_color = "000000".color
    Font.default_color = "ffffff".color
    Font.default_shadow = false
	#==========================================================================
	# • Skyrim : Setting
	#==========================================================================
	module Skyrim
		#----------------------------------------------------------------------
		# • Constantes & Variável.
		#----------------------------------------------------------------------
		FONT = {}
		FILENAME_SAVE = "Save"
		LIMIT_GOLD = 999999
		#----------------------------------------------------------------------
		# • Configuração dos gráficos gerais.
		#----------------------------------------------------------------------
		GRAPHIC = {
			# Layout de fundo nos menu. Caso não queira deixa as aspas vázia("").
   		    # Caso queira ponha o nome dentro das aspas.
    		LAYOUTBACK: "",#Layout Background
    		# Efeito blur no layout de fundo.
    		LAYOUTBACKBLUR: true,
				# Layout do menu de Item.
				LAYOUTITEM: "Layout Item",
    		# Fundo da barra
    		BACKBAR: "BackBar",
    		# Funda da barra 2
    		BACKBAR2: "BackBar2",
    		# Barra de hp.
    		HPBAR: "HpBar",
    		# Barra de Skill
    		SKILLBAR: "SkillBar",
    		# Barra de Xp
    		XPBAR: "XpBar",
    		# Barra de hp 2.
    		HPBAR2: "HpBar2",
    		# Barra de Skill 2
    		SKILLBAR2: "SkillBar2",
    		# Barra de Xp 2.
    		XPBAR2: "XpBar2",
    		# Gráfico do Mouse. DEVE ESTAR NA PASTA SYSTEM
    		MOUSE: "",
    		# Gráfico do cursor do menu.
    		CURSOR: "Cursor",
    		# Gráfico do cursor-index do menu.
    		INDEX: "Indexor",
    		# Skin do Menu
    		SKIN_UI: ["SkinUIMenu", "SkinUIMenu2"],
    		# Config. do Menu.
    		MENU: {
     				WINDOW: "Windows 1",
      			WINDOW2: "Windows 2",
      			WINDOW3: "Windows 3",
    		},
		}
		#----------------------------------------------------------------------
		# • Configuração da tela de título
		#----------------------------------------------------------------------
		TITLE = {
			# Configuração dos gráficos da title.
			GRAPHIC: {
				ICON_LOGO:		"Icon.png",
			},
			# Configuração da posição.
			POS: {
				ICON_ADD:				{x: 96, y: 0}.position,
				OPTION:	        {x: Graphics.width - 96, y: Graphics.height - 96}.position,
				SKIN_UI:        {x: 272, y: 0}.position
			},
			# Configuração das opções.
			OPTION: [
				{ title: "NOVO JOGO", 		handler: :new_game },
				{ title: "CONTINUAR", 		handler: :continue },
				{ title: "SAIR", 			handler: :shutdown }
			],
			# Configuração da partícula de fumaça.
			PARTICLE: {
				TIME_NEW:	10,
				POS:	{x: -64, y: (Graphics.height+128)*2}.position
			}
		}
		#----------------------------------------------------------------------
		# • Configuração do menu principal.
		#----------------------------------------------------------------------
		MAIN_MENU = {
			# Configuração das opções.
			OPTION: [

				{ title: "INVENTÁRIO",		handler: :menu_item },
				{ title: "HABILIDADES",		handler: :menu_skill },
				{ title: "EQUIPAMENTOS",	handler: :menu_equip },
				{ title: "SISTEMA",			handler: :menu_system }

			],
			# Configuração das opções do sistema.
			SYSTEM_OPTION: [

				{ title: "SALVAR",			handler: :menu_save,	enable: "$game_system.save_disabled" },
				{ title: "CARREGAR",		handler: :menu_load,	enable:  "!DataManager.save_file_exists?" },
				{ title: "SAIR",				handler: :menu_quit }

			],
			# Configuração dos textos.
			TEXT: {
				GOLD:							"OURO:",
				# Textos do menu de status.
    			STATUS: {
      				LEVEL: "Level ",
      				HP: "Hp ",
      				EXP: "Exp. Total ",
      				NEXP: "Pró. Nível ",
      				MP: "Mp ",
    			},
			},
			# Configuração da posição.
			POS: {
					ADDON_STATUS_X: 0,
    			ADDON_STATUS_Y: 0,
    			ADDON_STATUS_IN_Y: 0,
			},

		}
		#----------------------------------------------------------------------
		# • Configuração dos itens.
		#----------------------------------------------------------------------
		ITEM = {
			# Opções.
			OPTION: [
				{ title: "ITEM", 			handler: :category_item },
				{ title: "ARMAS",			handler: :category_weapon },
				{ title: "ARMADURAS",		handler: :category_armor },
				{ title: "CHAVES",			handler: :category_key }
			]
		}
		#----------------------------------------------------------------------
		# • Configuração dos equipamentos.
		#----------------------------------------------------------------------
		EQUIP = {
			# Opções
			OPTION: [
				{ title: "TROCAR",						handler: :change_equip },
				{ title: "OPTIMIZAR",					handler: :optimize_equip },
				{ title: "REMOVER TUDO",			handler: :remove_equip }
			],
			# Opções das categorias.
			CATEGORY: [
				{ title: "ARMAS",							handler: :weapon },
				{ title: "ARMADURAS",					handler: :armor },
				{ title: "ESCUDOS",						handler: :shield },
				{ title: "CABEÇA",						handler: :head },
				{ title: "ACESSÓRIO",					handler: :accessory }
			]
		}
		#----------------------------------------------------------------------
		# • Configuração das cores.
		#----------------------------------------------------------------------
		COLOR = {
			SYSTEM: "a24646",
		}
		#----------------------------------------------------------------------
		# • Configuração da Fonte.
		#----------------------------------------------------------------------
		# Fonte PADRÃO.
		FONT[:DEFAULT] = {
			NAME: "Futura MdCn BT",
     	    SIZE: 18,
        	BOLD: false,
        	ITALIC: false,
        	OUTLINE: false,
        	COLOR: "FFFFFF",
        	OUTCOLOR: "000000",
       	    SHADOW: false
		}
		# Fonte BUTTON.
		FONT[:BUTTON] = {
			NAME: "Futura MdCn BT",
     	    SIZE: 22,
        	BOLD: false,
        	ITALIC: false,
        	OUTLINE: false,
        	COLOR: "FFFFFF",
        	OUTCOLOR: "000000",
       	    SHADOW: false
		}
		# Fonte SUB
		FONT[:SUB] = {
			NAME: "Futura MdCn BT",
     	    SIZE: 16,
        	BOLD: false,
        	ITALIC: false,
        	OUTLINE: false,
        	COLOR: "FFFFFF",
        	OUTCOLOR: "000000",
       	    SHADOW: false
		}
		# Fonte ITEM.
		FONT[:ITEM] = {
			NAME: "Futura MdCn BT",
     	    SIZE: 18,
        	BOLD: false,
        	ITALIC: false,
        	OUTLINE: false,
        	COLOR: "FFFFFF",
        	OUTCOLOR: "000000",
       	    SHADOW: false
		}
		#----------------------------------------------------------------------
		# • Proc da fonte.
		#----------------------------------------------------------------------
		def self.bit_font
			->(object, sym=:DEFAULT) {
				return if object.nil?
				bitmap = object.is_a?(Bitmap) ? object : object.bitmap
				bitmap.font.name = FONT[sym].get(:NAME) || "Arial"
   	  	    	bitmap.font.size = FONT[sym].get(:SIZE) || 24
      			bitmap.font.bold = FONT[sym].get(:BOLD) || false
      			bitmap.font.italic = FONT[sym].get(:ITALIC) || false
      			bitmap.font.shadow = FONT[sym].get(:SHADOW) || false
      			bitmap.font.outline = FONT[sym].get(:OUTLINE) || false
      			bitmap.font.out_color = FONT[sym].get(:OUTCOLOR).color || Color.new.hex("000000")
     	    	bitmap.font.color = FONT[sym].get(:COLOR).color || Color.new.default
			}
		end
	end
	#==========================================================================
	# • Cache : Module
	#==========================================================================
	class << Cache
		#----------------------------------------------------------------------
	    # • Carregar arquivos da pasta Skyrim. ./Graphics/Skyrim
		#----------------------------------------------------------------------
		def skyrim(filename)
			load_bitmap("./Graphics/Skyrim/", filename)
		end
	end
	#==========================================================================
	# • Skyrim : Particle
	#==========================================================================
	module Skyrim::Particle
		#----------------------------------------------------------------------
		# • Variáveis.
		#----------------------------------------------------------------------
		@@_data = []
		#----------------------------------------------------------------------
		# • Adicionar partícula.
		#----------------------------------------------------------------------
		def self.add(*args)
			@@_data << Class.new(Sprite) do
				#--------------------------------------------------------------
				# • Inicialização dos objetos
				#		* pos : Posição X, Y.
				#		* _path : Nome do arquivo.
				#		* acc : Aceleração das partículas.
				#		* grav : Efeito de gravidade.
				#		* opacity : Controle da opacidade.
		        # 		* blend : Controle do efeito blend.
				#		* zoom : Controle do Zoom. X, Y.
				#       * hue : Controle da tonalidade HUE.
				#		* blur : Controle do blur.
				#		* color : Mudança de cor.
				#		* z : Prioridade.
				#--------------------------------------------------------------
				def initialize(pos, _path, acc, grav, opacity, blend, zoom, hue=360, blur=0, color=nil, z=10e2)
					super(_path)
					self.x, self.y = *pos.to_a
					self.ox = self.oy = self.bitmap.width / 2
					self.blend_type = blend
   				    self.opacity = opacity[0]
      				self.z = z
     			    self.bitmap.hue_change(hue)
      				blur.times { self.bitmap.blur } if blur > 0
      				@origin = [self.x, self.y]
      				@acceleration = acc
      				@gravity = grav
      				@zoom = zoom
      				@coords = [0.00, 0.00]
      				@opacity = opacity[1]
      				self.color = color.color unless color.nil?
     			    update
				end
				#--------------------------------------------------------------
				# • Atualização da partícula.
				#--------------------------------------------------------------
				def update
				  return if self.bitmap.disposed? or self.bitmap.nil? or self.nil?
      			  @acceleration[0] -= @gravity[0] unless @gravity[0] == 0
   				  @acceleration[1] -= @gravity[1] unless @gravity[1] == 0
     			  @coords[0] += @acceleration[0]
     			  @coords[1] += @acceleration[1]
      			  self.opacity -= @opacity
                  self.x = @origin[0] + @coords[0]
                  self.y = @origin[1] + @coords[1]
                  self.zoom_x += @zoom[0]
                  self.zoom_y += @zoom[1]
			    end
			end.new(*args)
		end
		#----------------------------------------------------------------------
		# • Adicionar partícula especial de fumaça.
		#----------------------------------------------------------------------
		def self.smoke(pos)
	    	gravity = [
				Random.new.rand(-1.5..1.5),
				Random.new.rand(-0.3..0.3)
			]
			acceleration = [
				5 * ( -25 + rand(10) ) / 10,
				Random.new.rand(-10..10)
			]
			self.add(pos, "./Graphics/Skyrim/smoke3.png", acceleration, gravity,
			[128, 2], 1, [0.05, 0.05], 360, 0, "fff6ca")
		end
		#----------------------------------------------------------------------
		# • Limpar tudo.
		#----------------------------------------------------------------------
		def self.clear
			return if @@_data.empty?
		    @@_data.each(&:dispose)
		    @@_data.clear
		    Cache.clear
		end
		#----------------------------------------------------------------------
		# • Atualização
		#----------------------------------------------------------------------
		def self.update
			@@_data.each_with_index do |data, index|
				next if data.disposed?
				data.update
				next unless data.opacity <= 0
				data.dispose
				@@_data.delete_at(index)
			end
		end
	end
	#==========================================================================
	# • Button : Skyrim.
	#==========================================================================
	class Skyrim::Button < Sprite
		#----------------------------------------------------------------------
		# • Variáveis da instância.
		#----------------------------------------------------------------------
		attr_accessor :active
  		attr_accessor :use
		attr_accessor :handler
		attr_accessor :index
  		#----------------------------------------------------------------------
  		# • Inicialização dos objetos.
  		#----------------------------------------------------------------------
  		def initialize(pos, text, sym=:BUTTON, align=1, w=64, h=24, z = 255)
			pos = pos.position unless pos.is_a?(Position)
    		super([w, h, pos.x || 0, pos.y || 0, z])
    		self.opacity = 127
   		    @active = false
    		@use = true
			@handler = nil
			@index = 0
			Skyrim.bit_font[self.bitmap, sym]
    		self.bitmap.draw_text_rect(text, align)
  		end
		#----------------------------------------------------------------------
  		# • Deletar os objetos.
 		#----------------------------------------------------------------------
  		def dispose
    		self.bitmap.dispose
   		 	super
  		end
 	   #----------------------------------------------------------------------
 	   # • Atualização dos objetos.
  	   #----------------------------------------------------------------------
  	   def update
   			return unless self.visible
    		super
  	   end
  	   #----------------------------------------------------------------------
  	   # • O que irá acontecer sê o mouse estiver em cima do sprite?
 	   #----------------------------------------------------------------------
  	   def mouse_over
        	self.opacity = @use ? 255 : 127
  	   end
  	   #----------------------------------------------------------------------
  	   # • O que irá acontecer sê o mouse não estiver em cima do sprite?
  	   #----------------------------------------------------------------------
  	   def mouse_no_over
   	    	self.opacity = 127
   	    	@active = false
  	   end
  	   #----------------------------------------------------------------------
  	   # • O que irá acontecer sê o mouse clicar no objeto
  	   #----------------------------------------------------------------------
  	   def mouse_click
    	   @active = @use
       end
	end
	#==========================================================================
	# • SkinUI : Skyrim
	#==========================================================================
	class Skyrim::SkinUI < Sprite
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		def initialize(pos, width, height, invert=false, z=200)
			pos = pos.position unless pos.is_a?(Position)
			super([width, height, pos.x, pos.y, z])
			_bit = Cache.skyrim(Skyrim::GRAPHIC[:SKIN_UI][invert.boolean])
			bitmap.stretch_blt(self.rect, _bit, _bit.rect)
			_bit.dispose
		end
	end
	#==============================================================================
	# • Scene_Base
	#==============================================================================
	class Scene_Base
		alias :mouse_main :main
  def main
    Mouse.graphic(Skyrim::GRAPHIC.get(:MOUSE))
    mouse_main
  end

  alias :mouse_terminate :terminate
  def terminate
    mouse_terminate
    Mouse.cursor.dispose
  end

  		def return_scene_key
    		[:B, 0x02].each { |i| trigger?(i) { return_scene } }
  		end
	end
	#==============================================================================
	# • Scene_MenuBase
	#==============================================================================
	class Scene_MenuBase < Scene_Base
  		#--------------------------------------------------------------------------
  		# * Criação do plano de fundo
  		#--------------------------------------------------------------------------
  		def create_background
    		@background_sprite = Sprite.new
    		if Skyrim::GRAPHIC.get(:LAYOUTBACK).empty?
      			@background_sprite.bitmap = SceneManager.background_bitmap
      			@background_sprite.color.set(16, 16, 16, 96)
    		else
      			@background_sprite.bitmap = Cache.skyrim(Skyrim::GRAPHIC.get(:LAYOUTBACK))
      			@background_sprite.bitmap.blur if Skyrim::GRAPHIC.get(:LAYOUTBACKBLUR)
    		end
  		end
	end
	#==========================================================================
	# • Window_SaveFile
	#==========================================================================
	class Window_LoadList < Window_Selectable
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		def initialize(x, y, width, height)
			super(x, y, width, height)
			self.opacity = 0
			@data = []
		end
		#----------------------------------------------------------------------
		# • Aquisição do número máximo de colunas.
		#----------------------------------------------------------------------
		def col_max
			return 1
		end
		#----------------------------------------------------------------------
		# • Aquisição do número máximo.
		#----------------------------------------------------------------------
		def item_max
			@data ? @data.size : 1
		end
		#----------------------------------------------------------------------
		# • Criar a lista de itens.
		#----------------------------------------------------------------------
		def make_item_list
			@data = Dir.glob("#{Skyrim::FILENAME_SAVE}*.rvdata2")
		end
		#----------------------------------------------------------------------
		# • Criar os itens.
		#----------------------------------------------------------------------
		def draw_item(index)
			item = @data[index]
			return unless item
			rect = item_rect(index)
			item = item.gsub!(/.(\w+)?$/, "")
			draw_text_ex(rect.x, rect.y, item)
		end
		#----------------------------------------------------------------------
		# • Renovação
		#----------------------------------------------------------------------
		def refresh
			make_item_list
			create_contents
			draw_all_items
		end
	end
	#==========================================================================
	# • Window_SaveFile
	#==========================================================================
	class Window_SaveList < Window_Selectable
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		def initialize(x, y, width, height)
			super(x, y, width, height)
			self.opacity = 0
			@data = []
		end
		#----------------------------------------------------------------------
		# • Aquisição do número máximo de colunas.
		#----------------------------------------------------------------------
		def col_max
			return 1
		end
		#----------------------------------------------------------------------
		# • Aquisição do número máximo.
		#----------------------------------------------------------------------
		def item_max
			DataManager.savefile_max
		end
		#----------------------------------------------------------------------
		# • Criar a lista de itens.
		#----------------------------------------------------------------------
		def make_item_list
			@data.clear
			(1..item_max).each do |n|
				@data << "#{Skyrim::FILENAME_SAVE} %02d" % n
			end
		end
		#----------------------------------------------------------------------
		# • Criar os itens.
		#----------------------------------------------------------------------
		def draw_item(index)
			item = @data[index]
			return unless item
			rect = item_rect(index)
			draw_text_ex(rect.x, rect.y, item)
		end
		#----------------------------------------------------------------------
		# • Renovação
		#----------------------------------------------------------------------
		def refresh
			make_item_list
			create_contents
			draw_all_items
		end
	end
	#==========================================================================
	# • Skyrim::Bar
	#==========================================================================
	class Skyrim::Bar < Sprite
		#----------------------------------------------------------------------
		# • Incluir
		#----------------------------------------------------------------------
  		include Skyrim
		#----------------------------------------------------------------------
		# • Variáveis da instância.
		#----------------------------------------------------------------------
  		attr_accessor :current, :current_max
  		#----------------------------------------------------------------------
  		# • Inicialização dos objetos.
  		#----------------------------------------------------------------------
  		def initialize(sym, current, current_max, x, y, bk=0)
    		super(nil)
    		self.x, self.y = x, y
    		self.bitmap = Cache.skyrim(GRAPHIC.get(bk == 0 ? :BACKBAR : :BACKBAR2))
    		@bitmap = Cache.skyrim(GRAPHIC.get(sym))
    		@bar = Sprite.new([self.width, self.height])
    		@current, @current_max = current, current_max
    		@bk = bk
    		update
  		end
  		#----------------------------------------------------------------------
  		# • Renovação dos objetos.
  		#----------------------------------------------------------------------
  		def dispose
    		@bar.bitmap.dispose
    		self.bitmap.dispose
    		@bitmap.dispose
    		@bar.dispose
    		super
  		end
  		#----------------------------------------------------------------------
  		# • Atualização dos objetos.
  		#----------------------------------------------------------------------
  		def update
    		@bar.z = self.z + 5
    		@bar.x, @bar.y = @bk == 0 ? self.x + 11 : self.x + 16, @bk == 0 ? self.y + 3 : self.y + 4
    		@bar.bitmap.clear
    		rect = Rect.new(0, 0, self.width.to_p(@current, @current_max), self.height)
    		@bar.bitmap.blt(0, 0, @bitmap, rect)
  		end
  		#----------------------------------------------------------------------
		# • Definir posição geral.
		#----------------------------------------------------------------------
  		def pos(x, y)
    		self.x, self.y = x, y
  		end
  		#----------------------------------------------------------------------
		# • Definir opacidade geral.
		#----------------------------------------------------------------------
  		def op=(val,ac=false)
    		[@bar, self].each { |i|
      			i.opacity = val unless ac
      			i.opacity += val if ac
    		}
  		end
  		#----------------------------------------------------------------------
		# • Aumentar ou diminuir opacidade.
		#----------------------------------------------------------------------
  		def opa(val)
    		[@bar, self].each { |i|
     			 i.opacity += val unless i.opacity >= 255 or i.opacity < 0
    		}
  		end
	end
	#==========================================================================
	# • Cursor :cursor
	#==========================================================================
	class Skyrim::Cursor < Sprite
  		#----------------------------------------------------------------------
  		# • Inicialização dos objetos.
  		#----------------------------------------------------------------------
  		def initialize(x=nil, y=nil, mirror=true, z=355)
    		super(nil)
    		self.bitmap = Cache.skyrim(Skyrim::GRAPHIC.get(:CURSOR))
    		self.mirror! if mirror
   			self.opacity = 32
    		self.x, self.y, self.z = x || 0, y || 0, z || 0
  		end
	end
	#==========================================================================
	# • Status Icon : Skyrim
	#==========================================================================
	class Skyrim::Status_Icon < Sprite
		#----------------------------------------------------------------------
		# • Constante.
		#----------------------------------------------------------------------
		TIME = 20
		#----------------------------------------------------------------------
		# • Variáveis da instância.
		#----------------------------------------------------------------------
		attr_accessor :user
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		def initialize(user, pos, z=201)
			@_current = 0
			@user = user
			@time = 0
			pos = pos.position unless pos.is_a?(Position)
			super([24, 24, pos.x, pos.y, z])
			@icons = (@user.state_icons + @user.buff_icons)[0, 24]
			self.bitmap.draw_icon(@icons[0], 0, 0)
		end
		#----------------------------------------------------------------------
		# • Atualização dos objetos
		#----------------------------------------------------------------------
		def update
			if @time > TIME
				self.bitmap.clear
				@current = @current.next % (@user.state_icons + @user.buff_icons)[0, 24].size rescue 0
				bitmap.draw_icon((@user.state_icons + @user.buff_icons)[0, 24][@current], 0, 0)
     		    @time = 0
			else
				@time += 1
			end
		end
	end
	#==========================================================================
	# • Sprite_Paragrah : Skyrim
	#==========================================================================
	class Skyrim::Sprite_Paragrah < Sprite
  		#----------------------------------------------------------------------
  		# • Inicialização dos objetos.
  		#----------------------------------------------------------------------
  		def initialize(x, y, width, height, text, z=251, space = 24)
    		super([width, height, x, y, z])
    		@text = text.to_s.split(/\n/)
    		Skyrim.bit_font[self.bitmap, :SUB]
   		    @space = self.bitmap.font.size+1
    		@rect = ->(i) { Rect.new(0, (@space*(i||0)), self.width, self.height) }
    		@text.each_with_index { |str,i|
    			str = i == @text[0].split(/\n/).size-1 ? str.backslash : str unless @text.last.empty?
      			#self.bitmap.draw_text(@rect[i], str, 1)
						dmath_format_paragraph(str, [@rect[i].x, @rect[i].y+self.y], 27, [self.width, @space], 1)
    		}
  		end
  		#----------------------------------------------------------------------
  		# • Update
  		#----------------------------------------------------------------------
  		def update
    		self.bitmap.clear
    		super
    		@text.each_with_index { |str,i|
     			str = i == @text[0].split(/\n/).size-1 ? str.backslash : str unless @text.last.empty?
      			#self.bitmap.draw_text(@rect[i], str, 1)
						dmath_format_paragraph(str, [@rect[i].x, @rect[i].y+self.y], 47, [self.width, @space], 1)
    		}
  		end
        #----------------------------------------------------------------------
		# • Definir novo texto.
		#----------------------------------------------------------------------
  		def text=(v)
    		@text = v.to_s.split(/\n/)
  		end
	end
	#==========================================================================
	# • Sprite_Status :sprite_status
	#==========================================================================
	class Skyrim::Sprite_Status
		#----------------------------------------------------------------------
		# • Incluir.
		#----------------------------------------------------------------------
		include Skyrim
		#----------------------------------------------------------------------
		# • Variáveis da instância.
		#----------------------------------------------------------------------
		attr_accessor	:visible
		attr_accessor 	:z
		attr_accessor	:user
		#----------------------------------------------------------------------
		# • Inicialização dos objetos.
		#----------------------------------------------------------------------
		def initialize
			@visible = false
			@z = 550
			@user ||= $game_party.members[0]
			@window = Sprite.new
			@window.bitmap = Cache.skyrim(GRAPHIC[:MENU][:WINDOW2])
			@window.position(:center_right)
			@window_x = @window.x
			@window.x += 128
			@window.opacity = 0
			setup
			[@window, @name, @face, @leveltext, @level, @hptext, @hp, @mptext,
			@mp, @exptext, @exp, @nexptext, @nexp, @equips, @params, @desc].each_with_index do |data, n|
				data.visible = @visible
				data.z = @z + n.next
				next if n.zero?
				data.x += MAIN_MENU[:POS][:ADDON_STATUS_X]
      	data.y += MAIN_MENU[:POS][:ADDON_STATUS_Y]
			end
		end
		#----------------------------------------------------------------------
		# • Elementos.
		#----------------------------------------------------------------------
		def setup
			@name = Sprite_Text.new(0, 0, @window.width, 32, "")
    		@face = Sprite.new([96, 96])
    		@leveltext = Sprite.new([64, 32, 0, 0, @z])
    		@level = Sprite.new([64, 32, 0, 0, @z])
    		@hptext = Sprite.new([32, 32, 0, 0, @z])
    		@hp = Sprite.new([96, 32, 0, 0, @z])
    		@mptext = Sprite.new([32, 32, 0, 0, @z])
    		@mp = Sprite_Text.new(0, 0, 96, 32, "")
    		@exptext = Sprite.new([64, 32, 0, 0, @z])
    		@exp = Sprite.new([72, 32, 0, 0, @z])
    		@nexptext = Sprite.new([64, 32, 0, 0, @z])
    		@nexp = Sprite.new([72, 32, 0, 0, @z])
    		@equips = Sprite.new([164, 164])
    		@params = Sprite.new([164, 164])
    		@desc =  Sprite.new([256,256,0,0,351]) #Skyrim::Sprite_Paragrah.new(0,0,256,256,"",351, 24)

				@name.x, @name.y = 160, @window.y + 28
    		@face.x, @face.y = 160, @name.y + 32
    		@leveltext.x, @leveltext.y = @face.x + 112, @face.y - 6
    		@level.x, @level.y = @leveltext.x + 32, @leveltext.y
    		@hptext.x, @hptext.y = @leveltext.x, @leveltext.y + 24
    		@hp.x, @hp.y = @level.x, @level.y + 24
    		@mptext.x, @mptext.y = @hptext.x, @hptext.y + 24
    		@mp.x, @mp.y = @hp.x, @hp.y + 24
    		@exptext.x, @exptext.y = @mptext.x, @mptext.y + 24
    		@exp.x, @exp.y = @mp.x + 12 , @mp.y + 24
    		@nexptext.x, @nexptext.y = @exptext.x, @exptext.y + 24
    		@nexp.x, @nexp.y = @exp.x, @nexptext.y
    		@equips.x, @equips.y = 160, 208 + MAIN_MENU[:POS][:ADDON_STATUS_IN_Y]
    		@params.x, @params.y = @exp.x + 74, @window.y + 28
    		@desc.x, @desc.y = @equips.x + 96, 116 + MAIN_MENU[:POS][:ADDON_STATUS_IN_Y]
		end
		#----------------------------------------------------------------------
		# • Deletar os objetos.
		#----------------------------------------------------------------------
		def dispose
			[@window, @name, @face, @leveltext, @level, @hptext, @hp, @mptext,
			@mp, @exptext, @exp, @nexptext, @nexp, @equips, @params, @desc].each(&:dispose)
		end
		#----------------------------------------------------------------------
		# • Atualizar os objetos.
		#----------------------------------------------------------------------
		def update
			if @visible
				Opacity.sprite_opacity_out(@window, 5, 255)
				@window.slide_left(5, @window_x)
			else
				@window.opacity = 0
				@window.x = @window_x + 16
			end
			[@window, @name, @face, @leveltext, @level, @hptext, @hp, @mptext,
			@mp, @exptext, @exp, @nexptext, @nexp, @equips, @params, @desc].each_with_index do |data, n|
				data.visible = @visible
				data.z = @z + n.next
			end
		end
		#----------------------------------------------------------------------
		# • Desenhar os status.
		#----------------------------------------------------------------------
		def refresh
			return unless @user.is_a?(Game_Actor)
			[@desc].each(&:update)
    		[@name, @face, @leveltext, @level, @hptext, @hp, @mptext,
			@mp, @exptext, @exp, @nexptext, @nexp, @equips, @params].each do |data|
				data.bitmap.clear
			end
    		Skyrim.bit_font[@name.bitmap, :SUB]
    		Skyrim.bit_font[@leveltext.bitmap, :SUB]
    		Skyrim.bit_font[@leveltext.bitmap, :SUB]
    		Skyrim.bit_font[@level.bitmap, :SUB]
    		Skyrim.bit_font[@hptext.bitmap, :SUB]
    		Skyrim.bit_font[@hp.bitmap, :SUB]
    		Skyrim.bit_font[@mptext.bitmap, :SUB]
    		Skyrim.bit_font[@mp.bitmap, :SUB]
    		Skyrim.bit_font[@exptext.bitmap, :SUB]
    		Skyrim.bit_font[@exp.bitmap, :SUB]
    		Skyrim.bit_font[@equips.bitmap, :SUB]
    		Skyrim.bit_font[@params.bitmap, :SUB]
    		Skyrim.bit_font[@desc.bitmap, :SUB]
    		Skyrim.bit_font[@nexptext.bitmap, :SUB]
    		Skyrim.bit_font[@nexp.bitmap, :SUB]
    		@name.bitmap.draw_text_rect(@user.name + " — " + @user.nickname)
    		@face.bitmap.draw_actor_face(@user, 0, 0)
    		@leveltext.bitmap.draw_text_rect(MAIN_MENU[:TEXT][:STATUS][:LEVEL])
    		@level.bitmap.draw_text_rect( sprintf("%02d", @user.level))
    		@hptext.bitmap.draw_text_rect(MAIN_MENU[:TEXT][:STATUS][:HP])
   		  @hp.bitmap.draw_text_rect(sprintf("%s/%s", @user.hp, @user.mhp))
    		@mptext.bitmap.draw_text_rect MAIN_MENU[:TEXT][:STATUS][:MP]
    		@mp.bitmap.draw_text_rect(sprintf("%s/%s", @user.mp, @user.mmp))
    		s1 = @user.max_level? ? "-------" : @user.exp
    		s2 = @user.max_level? ? "-------" : @user.next_level_exp - @user.exp
    		@exptext.bitmap.draw_text_rect(MAIN_MENU[:TEXT][:STATUS][:EXP])
    		@exp.bitmap.draw_text_rect(s1, 1)
    		@equips.bitmap.draw_equipments(@user, 0, 0)
    		@params.bitmap.draw_parameters(@user, 0, 0)
				@desc.bitmap.clear
    		@desc.dmath_format_paragraph(@user.description, [16,96], 20)
    		@nexptext.bitmap.draw_text_rect(MAIN_MENU[:TEXT][:STATUS][:NEXP])
    		@nexp.bitmap.draw_text_rect(s2, 1)
		end
	end
	#==========================================================================
	# • Sprite
	#==========================================================================
	class Sprite
  		include Skyrim
  		#----------------------------------------------------------------------
  		# • Desenha os status de equip.
  		#----------------------------------------------------------------------------
  		def menu_equip(data)
    		return if data.nil?
    		self.bitmap.clear
    		Skyrim.bit_font[self.bitmap, :ITEM]
    		self.bitmap.draw_text(12, 4, 164, 24, data.name)
    		6.times { |i| draw_item_name(12, 48+(i*20), i, data) }
    		bitmap.draw_equipments(data, 12, 184)
  		end
  		#----------------------------------------------------------------------
 		# • Texto quebrado em relação ao tamanho definido.
 		#----------------------------------------------------------------------
  		def dmath_format_paragraph(text, pos, ch, wh=[self.width, 20], align=1)
    		atext = text.split(/\n/)
    		natext = ["", ""]
    		atext.each_with_index { |str, id|
      			(str.size/ch).times { |i| str.insert(ch*i, "-\n") if i > 0 }
      			natext[id] << str
    		}
    		natext[0].split(/\n/).each_with_index { |str,i|
      			str = i == natext[0].split(/\n/).size-1 ? str.backslash : str unless natext[1].empty?
      			self.bitmap.draw_text(pos[0], pos[1]+(wh[1]*i), wh[0], wh[1], str, align)
    		}
    		natext[1].split(/\n/).each_with_index { |str, i|
      			str = i == natext[1].split(/\n/).size-1 ? str.backslash : str
      			self.bitmap.draw_text(pos[0], (pos[1]+wh[1]*natext[0].split(/\n/).size) + (wh[1]*i), wh[0], wh[1], str, align)
    		}
  		end
  		#----------------------------------------------------------------------
		# • Desenhar item.
		#----------------------------------------------------------------------
  		def draw_item_name(x, y, i, data)
    		Skyrim.bit_font[bitmap, :SUB]
    		self.bitmap.font.color = COLOR[:SYSTEM].color
    		bitmap.draw_text(x, y, 80, 20, Vocab::param(i) + ":")
    		bitmap.font.color = Color.new.default
    		bitmap.draw_text(x+94, y+1, 32, 20, data.param(i), 1)
  		end
	end
	#==========================================================================
	# • Bitmap
	#==========================================================================
	class Bitmap
  		#----------------------------------------------------------------------
  		# * Desenho dos ícones de estado, foralecimento e enfraquecimento
  		#     actor  : herói
  		#     x      : coordenada X
  		#     y      : coordenada Y
  		#     width  : largura
  		#----------------------------------------------------------------------
 		 def draw_actor_icons(actor, x, y, width = 168)
    		icons = (actor.state_icons + actor.buff_icons)[0, width / 24]
    		icons.each_with_index {|n, i| draw_icon(n, x + 24 * i, y) }
  		end
  		#----------------------------------------------------------------------
  		# * Desenho dos parâmetros
  		#     x : coordenada X
  		#     y : coordenada Y
  		#----------------------------------------------------------------------
  		def draw_parameters(actor, x, y)
    		6.times {|i| draw_actor_param(actor, x, y + 24 * i, i + 2) }
  		end
  		#----------------------------------------------------------------------
  		# * Desenho dos parâmetros
  		#----------------------------------------------------------------------
  		def draw_actor_param(actor, x, y, param_id)
    		font.color = Skyrim::COLOR[:SYSTEM].color
    		draw_text(x, y, 120, 24, Vocab::param(param_id))
    		font.color = Color.new.default
    		draw_text(x + 64, y, 36, 24, actor.param(param_id), 2)
  		end
  		#----------------------------------------------------------------------
  		# * Desenho dos equipamentos
  		#     x : coordenada X
  		#     y : coordenada Y
  		#----------------------------------------------------------------------
 		def draw_equipments(actor, x, y)
    		actor.equips.each_with_index do |item, i|
      			draw_item_name(item, x, y + 24 * i)
    		end
  		end
  		#----------------------------------------------------------------------
  		# * Desenho do nome de itens
  		#----------------------------------------------------------------------
  		def draw_item_name(item, x, y, enabled = true, width = 172)
    		return unless item
    		draw_icon(item.icon_index, x, y, enabled)
    		draw_text(x + 24, y, width, 24, item.name)
  		end
  		#----------------------------------------------------------------------
  		# * Desenho do gráfico de rosto
  		#----------------------------------------------------------------------
  		def draw_face(face_name, face_index, x, y, enabled = true)
    		bitmap = Cache.face(face_name)
    		rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96, 96, 96)
    		self.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
    		bitmap.dispose
 		end
  		#----------------------------------------------------------------------
  		# * Desenho do gráfico de face do herói
  		#----------------------------------------------------------------------
  		def draw_actor_face(actor, x, y, enabled = true)
    		return unless actor.is_a?(Game_Actor)
    		draw_face(actor.face_name, actor.face_index, x, y, enabled)
  		end
	end
	#==========================================================================
	# • Carregar os arquivos.
	#==========================================================================

	# Carregar a tela de título.
	load_script($ROOT_PATH["skyrim_ui_.rb", "Skyrim/"])
}
