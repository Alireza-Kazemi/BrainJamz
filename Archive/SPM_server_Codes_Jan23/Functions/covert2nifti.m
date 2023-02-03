
function filesPath = covert2nifti(directory,destination)

dcmFiles = spm_select('FPList',directory,'.*.dcm');

hdr = spm_dicom_headers( char(dcmFiles) );


% % confirm expected slice acquisition order
% if isfield( hdr{1}, 'Private_0019_1029' )
%     orders = [];
%     vals = [];
%     for i = 1:length(hdr)
%         x = hdr{i}.Private_0019_1029;
%         [~,I] = sort( x); 
%         vals = cat(1,vals,x);
%         orders = cat(1,orders,I);
%     end
% %     x = hdr{1}.Private_0019_1029;
% %     n = length(x);
% %     [~,I] = sort( x);  
% %     order = I;
% %     if isempty(order), if mod(n,2) == 0, order = [2:2:n 1:2:n-1]; else order = [1:2:n 2:2:n-1]; end; end           
% %     if any( order ~= I ), disp('Unexpected slice order. Check dicom header.'); end
% end

cd(destination)
filesPath = spm_dicom_convert( hdr, 'all', 'flat', 'img' );

end