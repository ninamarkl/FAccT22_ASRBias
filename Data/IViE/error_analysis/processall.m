

clear; close all;
addpath(pwd)
all_files = dir; %read all files
conf_data = table(1,"", "", "");
ins_data = table(1,"", "");
del_data = table(1,"", "");
sub_data = table(1,"", "");


for dd = 1:length(all_files)
  
   if all_files(dd).isdir
        cd(all_files(dd).name)
        Files = dir;
       file_ind = [];
        for ll=1:length(Files) % loop through all files
            if endsWith(Files(ll).name,'_hyp.trn.dtl') % if correct ending, store index
                file_ind = [file_ind,ll];
            end
        end
        
        for ff = 1:length(file_ind) % loop through all files with correct ending
            %try
                data_temp = importall(Files(file_ind(ff)).name); % read entries
                
                % find sections 
                confstart=find(strcmp(string(data_temp.With), 'CONFUSION')); 
                insstart = find(strcmp(string(data_temp.With), 'INSERTIONS')); 
                delstart = find(strcmp(string(data_temp.With), 'DELETIONS')); 
                substart = find(strcmp(string(data_temp.With), 'SUBSTITUTIONS')); 
                subend = find(strcmp(string(data_temp.With), 'FALSELY')); 
                
                
                % set filename 
                filename = string(Files(file_ind(ff)).name);
                %temp_str = table(repmat(temp_str,no_entries,1));
                %data_temp(:,6) = temp_str;
                
                
                % make sections 
                
                % confusion pairs 
                
                conf_entries = (insstart)- confstart; % these are the number of relevant rows 
                conf_temp = [data_temp(confstart:insstart-1,[2,3,5]),table(repmat(filename, conf_entries, 1))];
                conf_temp(isnan(conf_temp.occurrences),:) = [];
               
                datasize = size(conf_data);
                conf_data(datasize(1)+1:datasize(1)+height(conf_temp),:) = conf_temp;
                conf_data.Properties.VariableNames = {'Count', 'correct', 'ASR', 'Filename'};
                
                % insertions 
                
                ins_entries = delstart- insstart; % these are the number of relevant rows 
                ins_temp = [data_temp(insstart:delstart-1,[2,3]),table(repmat(filename, ins_entries, 1))];
                ins_temp(isnan(ins_temp.occurrences),:) = [];
               
                datasize = size(ins_data);
                ins_data(datasize(1)+1:datasize(1)+height(ins_temp),:) = ins_temp;
                ins_data.Properties.VariableNames = {'Count', 'Inserted_Word', 'Filename'};
                
                  
                % deletions 
                
                del_entries = substart- delstart; % these are the number of relevant rows 
                del_temp = [data_temp(delstart:substart-1,[2,3]),table(repmat(filename, del_entries, 1))];
                del_temp(isnan(del_temp.occurrences),:) = [];
               
                datasize = size(del_data);
                del_data(datasize(1)+1:datasize(1)+height(del_temp),:) = del_temp;
                del_data.Properties.VariableNames = {'Count', 'Deleted_Word', 'Filename'};
                
                  
               
                % substitutions 
                
                sub_entries = subend- substart; % these are the number of relevant rows 
                sub_temp = [data_temp(substart:subend-1,[2,3]),table(repmat(filename, sub_entries, 1))];
                sub_temp(isnan(sub_temp.occurrences),:) = [];
               
                datasize = size(sub_data);
                sub_data(datasize(1)+1:datasize(1)+height(sub_temp),:) = sub_temp;
                sub_data.Properties.VariableNames = {'Count', 'Substituted_Word', 'Filename'};
                
                
                
               
                
            %catch 
              %  warning(['File ',Files(file_ind(ff)).name, ' was not parsed'])
            %end
        end
        
       
        cd ../
    end
    
end
writetable(conf_data, "google_confusion_summary.csv")
writetable(ins_data, "google_insertion_summary.csv")
writetable(del_data, "google_deletion_summary.csv")
writetable(del_data, "google_substitution_summary.csv")


