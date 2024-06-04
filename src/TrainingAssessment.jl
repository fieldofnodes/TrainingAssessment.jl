module TrainingAssessment

using Revise
using CSV
using DataFrames
using DataFramesMeta
using Chain
using BaseTrainingPlan
using TrainingContent


export
    write_table_to_file,
    generate_table,
    write_training_assessment_to_file




    function map_to_latex_color(number::Int)
        if number == 5
            return "\\cblue"
        elseif number == 4
            return "\\cgreen"
        elseif number == 3
            return "\\cyellow"
        elseif number == 2
            return "\\corange"
        elseif number == 1
            return "\\cpink"
        elseif number == 0
            return "\\cred"
        else
            error("Invalid number. Expected input: 0, 1, 2, 3, 4, or 5.")
        end
    end
    
    function generate_assessement_code_skill_latex(file_name::String)
        @chain file_name begin
            read_training_assessment_file(_)
            @rtransform :current_code = map_to_latex_color(:Current_skills)
            @rtransform :current_code_skill = string(:current_code, " ", :Skill, " \\\\")
            _.current_code_skill
        end
    end

    function write_training_assessment_results_to_table(training_assessment_results::Vector{String})
        latex_code = """
        \\chapter{Analysis of Current Skills and Experience}\\label{ch:candidate_analysis}
        \\chapterimage{graph2.png}
        \\section{Analysis of \\traineeName Current Skills \\& Experience}
        Candidate skills assessment yielded ranking from \$1\$ to \$5\$, no skill to completely, but in need of update,  skilled respectively.
    
        %\\cgreen
        %\\corange
        %\\cyellow
        %\\cblue
        %\\cred
        %\\cgray
    
        \\begin{center}
        {\\renewcommand{\\arraystretch}{1.3}%
        \\begin{tabular}{|p{.2\\textwidth}|p{.3\\textwidth}|}
        \\hline
        {\\cgray\\textbf{Skill level}} & {\\cgray\\textbf{Colour representation}} \\\\
        \\hline
        5 & \\cblue \\\\ 
        \\hline
        4 & \\cgreen \\\\
        \\hline
        3 & \\cyellow \\\\
        \\hline
        2 & \\corange\\\\
        \\hline
        1 & \\cpink \\\\
        \\hline
        0 & \\cred \\\\
        \\hline
        \\end{tabular}
        }
        \\end{center}
    
    
        \\begin{center}
        {\\renewcommand{\\arraystretch}{1.2}%
        \\begin{longtable}{|l|}
        \\hline 
        \\hline
        {\\cgray \\centering \\textbf{Candidate: \\traineeName}} \\\\
        \\hline
        \\hline
        {\\cgray\\centering \\textbf{Current Skills levels}} \\\\   
        \\hline 
        \\endhead
        \\hline 
        $(join(training_assessment_results,"\n"))
        \\hline
        \\end{longtable}
        \\end{center}
    
        The assessment of the candidate's skills revealed several specific areas that will be improved with the training focus of \\trainingFocus. 
    
    
        \\section{Determining Training Program best suited for the candidate}\\index{Determining Training Program best suited for the candidate}
    
        The training provided is comprehensive and holistic. For areas of expertise already known by the candidate, trainers can expedite those specific courses. Key subjects highlighted in red and pink will be especially targeted for in-depth exploration and skill-building sessions.
    
        Completion of the plan, work-based experiences, and consistent skill development will enhance the candidate's capabilities in the \\trainingFocus stream. This assessment serves as the basis for specialized training, maximizing the candidate's learning experiences. Candidates will undergo weekly on-the-job training and will be required to obtain approval from the trainer prior to further development through a series of competent and not-competent approval signatures.
    
        Note: The training approach is designed to prioritize subjects with the greatest impact within the allotted timeframe, acknowledging that not all topics will be covered.
        """
        return latex_code
    end

    function write_training_assessment_to_file(file_name_to_save::String,file_name_to_read::String)
        code_skill = generate_assessement_code_skill_latex(file_name_to_read)
        test_to_save = write_training_assessment_results_to_table(code_skill)
        open(file_name_to_save, "w") do file
            write(file, test_to_save)
        end
    end

    function generate_table_row(content_title::String, idx::Int)
        return """
        $content_title & \\TextField[name=current$(idx), width=2cm, bordercolor=, backgroundcolor=]{} & \\TextField[name=desired$(idx), width=2cm, bordercolor=, backgroundcolor=]{} \\\\
        \\hline
        """
    end



    function generate_document_header()
        return """
        \\documentclass{article}
        \\usepackage{geometry}
        \\usepackage{longtable}
        \\usepackage{array}
        \\usepackage[scaled]{helvet}
        \\usepackage{sectsty}
        \\usepackage{hyperref}

        \\allsectionsfont{\\sffamily}

        \\geometry{a4paper, left=1in, right=1in, top=1in, bottom=1in}

        \\begin{document}

        \\renewcommand{\\familydefault}{\\sfdefault}
        \\section{Skill analysis}

        Please read the following table. For each line put a number between \$0\$ and \$5\$, for no skill to expert respectively.

        \\large % Adjust the font size as needed
        \\renewcommand{\\arraystretch}{2} % Adjust the array stretch

        \\begin{longtable}{|p{0.45\\linewidth}|p{0.25\\linewidth}|p{0.25\\linewidth}|}
        \\hline
        \\textbf{Skill} & \\textbf{Current skill level} & \\textbf{Desired skill level} \\\\
        \\hline
        \\endhead

        \\hline
        \\endfoot
        """
    end

    function generate_document_footer()
        return """
        \\end{longtable}
        \\end{document}
        """
    end


    function generate_table(ttd::TrainingTableData)
        content_title = ttd.content_title
        contents = Base.OneTo(length(content_title))
        
        header = generate_document_header()
        rows = 
            [generate_table_row(content_title[i], i) for i in contents] |>
            x -> join(x,"\n")
        footer = generate_document_footer()
        
        return join([header,rows,footer], "\n")
    end

    function write_table_to_file(filename::String,ttd::TrainingTableData)
        table = generate_table(ttd)
        open(filename, "w") do file
            write(file, table)
        end
    end


end
