class ParseClippingService
    NOTE_SECTION_SEPARATOR = '=========='
    NOTE_DEFAULT_TITLE = 'Unknown title'
    NOTE_DEFAULT_AUTHOR = 'Unknown author'
    NOTE_DEFAULT_DATETIME = '1970-01-01 00:00:00'
    NOTE_LABEL = 'Note|笔记'
    HIGHLIGHT_LABEL = 'Highlight|标注'
    ADD_LABEL = 'Added on|添加于'

    attr_accessor :filepath
    def initialize(filepath)
        @filepath = filepath
    end

    # 解析为块
    def parseForSection
        sections = []
        if File.exist?(@filepath)
            section = ''
            File.open(@filepath, 'r') do |file|
                file.each_line do |line|
                    if line.start_with?(NOTE_SECTION_SEPARATOR)
                        sections.push(section)
                        section = ''
                    else
                        section.concat(line)
                    end
                end
            end
        end
        sections.delete_at(0)
        return sections
    end

    # 解析为片段
    def parseForFragment(sections = nil)
        sections ||= parseForSection() 
        fragments = []
        sections.each do |section| 
            fragment = {}
            fragment[:title_author], fragment[:type_date], fragment[:content] = section.split("\r", 3)

            # 提取片段的标题与作者
            /(.*)\((.*)\).*/ =~ fragment[:title_author]
            fragment[:title] = $1 || NOTE_DEFAULT_TITLE
            fragment[:author] = $2 || NOTE_DEFAULT_AUTHOR
            fragment.delete(:title_author)
                
            # 提取片段的类型与创建日期
            /(#{NOTE_LABEL}|#{HIGHLIGHT_LABEL}).*(#{ADD_LABEL})(.*)/ =~ (fragment[:type_date])
            fragment[:type] = $1
            fragment[:date] = $3 || NOTE_DEFAULT_DATETIME
            fragment.delete(:type_date)
            
            fragment[:content].lstrip!
            # 将片段添加到数组
            fragments.push(fragment)
        end

        return fragments
    end

    # 解析为笔记
    def parseForNote(fragments = nil)
        fragments ||= parseForFragment()
        notes = {}
        fragments.each do |fragment|
            title = fragment[:title]
            author = fragment[:author]
            fragment.delete(:title)
            fragment.delete(:author)

            if notes.has_key?(title)
                notes[title][:fragment].push(fragment)
            else
                notes[title] = {
                                            :title=>title, 
                                            :author=>author,
                                            :fragment =>[fragment]
                                }
            end
        end

        return notes
    end
end