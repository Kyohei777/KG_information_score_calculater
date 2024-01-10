require 'pdf-reader'

def extract_text_from_pdf(pdf_path)
  reader = PDF::Reader.new(pdf_path)
  text = ''

  reader.pages.each do |page|
    text << page.text
  end

  return text
end

def calculate_average_grades(data)
  

  #セメスタ数を取得
  semester = data.scan(/(\d+\.\d+)\s*(\d{4})\s*(\S{1})/)

  formatted_data = semester.map do |match|
    match[1..-1].join('')
  end   

  data_list = formatted_data.uniq

  #成績を抽出する
  grades_data = data.scan(/\(\d{6}\)\D*(\d{1,3})/)

  #合格科目の総和を計算する
  filtered_numbers = grades_data.flatten.reject { |num| num.to_i.zero? || num.to_i <= 59 }

  # 合格科目の平均点を計算
  average = filtered_numbers.any? ? filtered_numbers.map(&:to_i).reduce(:+).to_f / filtered_numbers.length : 0.0

  # 受講科目の平均点を計算
  all_average = if grades_data.any?
    grades_data.flatten.map(&:to_i).reduce(:+).to_f / grades_data.flatten.length
  else
    0.0
  end

  return average, filtered_numbers.length, data_list, all_average, grades_data.length
end

# PDFからテキストを抽出
#pdf_path = '2022_fall.pdf'
pdf_path = ARGV[0]
pdf_text = extract_text_from_pdf(pdf_path)

# テキストをファイルに書き出し
output_file_path = 'output.txt'
File.open(output_file_path, 'w') { |file| file.write(pdf_text) }
puts "テキストを #{output_file_path} に書き出しました。"

# 平均を計算
begin
  grades_data = File.read(output_file_path)
  average, number_of_classes_passed, semester, total_average,number_of_classes_taken  = calculate_average_grades(grades_data)

  #puts "指定の形式の数字: #{data_list} "
  puts "受講科目数: #{number_of_classes_taken}"
  puts "全体平均点: %.2f" % total_average
  
  puts "取得単位科目数: #{number_of_classes_passed}"
  puts "取得単位平均点: %.2f" % average
  

  grades = ((average - 50) * number_of_classes_passed) / semester.length
  puts "情報科学科における計算式: %.2f" % grades

  output_file_path = 'result.txt'

File.open(output_file_path, 'w') do |file|
  file.puts "受講科目数: #{number_of_classes_taken}"
  file.puts "全体平均点: %.2f" % total_average
  file.puts "取得単位科目数: #{number_of_classes_passed}"
  file.puts "取得単位平均点: %.2f" % average
  file.puts "情報科学科における計算式: %.2f" % grades
end

puts "結果を #{output_file_path} に書き出しました。"

rescue Errno::ENOENT
  puts "エラー: ファイルが見つかりません"
rescue StandardError => e
  puts "エラー: #{e.message}"
end
