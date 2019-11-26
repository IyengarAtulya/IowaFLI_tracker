function abc=TrackVideo_v8bNoSub(PATH, FILE, numflies, Thresh, roi, chksz,InitCoords,varargin)
%define background frame
%FlySize=varargin{1};
%Fly Size is the minimum number of pixels a fly can be
FlySize=200;
%md max distance fly can move frame to frame (in px)
md=round(size(roi,1)/5);
BiggestPossibleFly = 10000;
Rchange = 0.0;
Gchange = 0.0;
Bchange = 0.0;
oldB = 0.0;
oldR = 0.0;
oldG = 0.0;
Rvalue = 0.0;
Gvalue = 0.0;
Bvalue = 0.0;

if iscell(Thresh)
    thresh=Thresh{1};
    if strcmp(Thresh{2},'none')
       gradnorm=0; 
    elseif strcmp(Thresh{2},'gradnormalize')
        gradnorm=1; 
    end
elseif isnumeric(Thresh)
    thresh={1};
    gradnorm=0;
end



%vidobj is the video object -- created from the given file
try
    vidobj=VideoReader([PATH,FILE]);
catch
    try
        if(mmreader.isPlatformSupported())
            vidobj=mmreader([PATH,FILE]);
        end
    catch
        msgbox('Neither VideoReader nor mmreader supported by this matlab verison.  Fatal Error');
    end
end
%Collecting the size of the frame
h=waitbar(0, [num2str(0),'% Analyzing Background']);
VidWidth=vidobj.Width;
VidHeight=vidobj.Height;
%if variable frame rate, index last frame
lastFrame=read(vidobj,vidobj.NumberOfFrames-1);
%calculate the number of frame and the frame rate
nframes=vidobj.NumberOfFrames;
fps=vidobj.FrameRate;


oroi=roi;

%ROI DILATION size = ones(3)
dilate = 0;
if dilate ==1
  for i=1:size(roi,3)
   oroi(:,:,i) = imdilate(oroi(:,:,i),ones(3));  
  end
end



if ndims(roi)>2
    nroi=logical(sum(roi,3));
    clear roi
    roi=nroi;
end

nroi=zeros(size(roi));
for k=1:size(oroi,3)
    nroi=bsxfun(@max,nroi,oroi(:,:,k)*k);
end

for k=1:numflies
    flyroi(k)=nroi(InitCoords(k,2),InitCoords(k,1));
end

if nargin> 7
    if(~isempty(varargin{1}))
        Targets=varargin{1};
        if numel(Targets)>0
            isChoiceAssay=1;
        else
            isChoiceAssay=0;
            
        end
        roi=(roi&~logical(sum(Targets,3)));
        for i=1:size(oroi,3)
            oroi(:,:,i)=(oroi(:,:,i)&~logical(sum(Targets,3)));
        end
        isChoiceAssay=1;
    else
        isChoiceAssay=0;
    end
else
    roi=roi;
    isChoiceAssay=0;
end

if nargin>8
    startFrame=varargin{2};
else
    startFrame=1;
end

roi = im2bw(roi);



ROIleft = floor(min(find(roi==1))/VidHeight);
if ROIleft<1
    ROIleft=1;
end
ROIright = ceil(max(find(roi==1))/VidHeight);
if ROIright>size(roi,2)
    ROIright=size(roi,2);
end

% Heuristic method to generate Y coord
remIdx =rem(find(roi==1),VidHeight);
ROIbottom = min(remIdx);
if ROIbottom<1
    ROIbottom = 1;
end
ROItop = max(remIdx);

% %create and set aside frames for background
if nframes < 450
    numforms =1;
else
    %numforms = floor((nframes-0)/450);
    numforms = floor((nframes-1)/450)-1;
end
for i=1:numforms
    bkfrms(:,:,:,i)=read(vidobj,i*450+startFrame);
end
% nbkfrms=size(bkfrms,4);
% for i=1:nbkfrms
%     bwbkfrm(:,:,i)=im2bw(bkfrms(:,:,:,i),thresh);
% end

% Rbk = mean(bkfrms(:,:,1,:),4);
% Gbk = mean(bkfrms(:,:,2,:),4);
% Bbk = mean(bkfrms(:,:,3,:),4);

Rbk = quantile(bkfrms(:,:,1,:),.8,4);
Gbk = quantile(bkfrms(:,:,2,:),.8,4);
Bbk = quantile(bkfrms(:,:,3,:),.8,4);

mbkfrm = uint8(zeros(VidHeight,VidWidth,3));
mbkfrm(:,:,1) = Rbk;
mbkfrm(:,:,2) = Gbk;
mbkfrm(:,:,3) = Bbk;
%mbwbkfrm=im2bw(mbkfrm,thresh);

RbkMean = mean(mean(Rbk(ROIbottom:ROItop,ROIleft:ROIright)));
GbkMean = mean(mean(Gbk(ROIbottom:ROItop,ROIleft:ROIright)));
BbkMean = mean(mean(Bbk(ROIbottom:ROItop,ROIleft:ROIright)));

% %background frame created

%nchunks- number of set of frames to analyze
%nchunk=floor(nframes-1/chksz)-1;
nchunk=floor((nframes-(1))/chksz)-1;

startChunk=floor(startFrame/chksz)+1;
sFrame=rem(startFrame,chksz);

% output is an array with frst row  being the frame number and even rows
% being x coords and odd rows being y coords
output=NaN((1+2*numflies),nchunk*chksz);

ErrorRate = zeros(3,nchunk*chksz);


dist = zeros(1,numflies);
count =0;




% 'nchunk'
% nchunk = 8;
waitbar(0,h, [num2str(0),'% completion']);

for i=startChunk:nchunk
    % tic
    
    
    waitbar(i/nchunk, h, [num2str(round(100*(i/nchunk))),'% completion']);
    if i==startChunk
        frames=read(vidobj,[(i-1)*chksz+sFrame,i*chksz]);
        sJ=sFrame;
        if sJ>1
            output(1,1:sJ-1)=[1:sJ-1];
        end
    else
        frames=read(vidobj,[(i-1)*chksz+1,i*chksz]);
        sJ=1;
    end
    
    Redvalue =mean(mean(frames(ROIbottom:ROItop,ROIleft:ROIright,1,1)));
    Greenvalue =mean(mean(frames(ROIbottom:ROItop,ROIleft:ROIright,2,1)));
    Bluevalue =mean(mean(frames(ROIbottom:ROItop,ROIleft:ROIright,3,1)));
    
    nmbkfrm = mbkfrm;
    
    nmbkfrm(ROIbottom:ROItop,ROIleft:ROIright,1) = mbkfrm(ROIbottom:ROItop,ROIleft:ROIright,1)+(Redvalue-RbkMean)*1.25;
    nmbkfrm(ROIbottom:ROItop,ROIleft:ROIright,2) = mbkfrm(ROIbottom:ROItop,ROIleft:ROIright,2)+(Greenvalue-GbkMean)*1.25;
    nmbkfrm(ROIbottom:ROItop,ROIleft:ROIright,3) = mbkfrm(ROIbottom:ROItop,ROIleft:ROIright,3)+(Bluevalue-BbkMean)*1.25;
    
    %nmbwbkfrm=im2bw(nmbkfrm,thresh);
    if gradnorm==0
        nmbwbkfrm=imbinarize(rgb2gray(mbkfrm),thresh);
    elseif gradnorm==1
        nmbwbkfrm=imbinarize(rgb2gray(mbkfrm),'adaptive','ForegroundPolarity','dark','Sensitivity',thresh);
    end
    
    
    for j=sJ:chksz
        try
        %md=size(roi,1)/10;
        currentframe=(i-1)*chksz+j;
        %disp(currentframe);
        
        
        stopframe =7;
        if currentframe == stopframe
            stop=1;
        end
        
        OKFlag = 0;
        
        try
            prevframe = rbwframe;
        end
        
%         %new fog filter code
%         try
%             if currentframe == 1
%                 
%                 FirstFrame = frames(:,:,:,1);
%                 
%                 Rvalue =mean(mean(frames(ROIbottom:ROItop,ROIleft:ROIright,1,j)));
%                 Gvalue =mean(mean(frames(ROIbottom:ROItop,ROIleft:ROIright,2,j)));
%                 Bvalue =mean(mean(frames(ROIbottom:ROItop,ROIleft:ROIright,3,j)));
%                 
%                 oldR = Rvalue;
%                 oldG = Gvalue;
%                 oldB = Bvalue;
%                 
%             else
%                 Rvalue =mean(mean(frames(ROIbottom:ROItop,ROIleft:ROIright,1,j)));
%                 Gvalue =mean(mean(frames(ROIbottom:ROItop,ROIleft:ROIright,2,j)));
%                 Bvalue =mean(mean(frames(ROIbottom:ROItop,ROIleft:ROIright,3,j)));
%                 
%                 
%                 Rchange = Rchange-oldR + Rvalue;
%                 Gchange = Gchange-oldG + Gvalue;
%                 Bchange = Bchange-oldB + Bvalue;
%                 
%                 
%                 if abs(Bchange) > 3 || abs(Rchange) > 3 || abs(Gchange) > 3
%                     %multipled by 1.3 to account for the dilution of
%                     %changes of a perfectly circular chamber in a square
%                     %roi
%                     frames(:,:,1,j) = frames(:,:,1,j) - Rchange;
%                     frames(:,:,2,j) = frames(:,:,2,j) - Gchange;
%                     frames(:,:,3,j) = frames(:,:,3,j) - Bchange;
%                 end
%                 
%                 oldR = Rvalue;
%                 oldG = Gvalue;
%                 oldB = Bvalue;
%                 
%                 %mean(mean(frames(:,:,1,j).*uint8(roi)-frames(:,:,1,1).*uint8(roi)))
%                 
%             end
%         end
%         
%         %end fog filter code
        
        
        %convert current frame to a BW frame at threshold level
        %bwframe=im2bw(frames(:,:,:,j),thresh);
        bf=rgb2gray(frames(:,:,:,(j-sJ+1)));
        if gradnorm==0
            bwframe=imbinarize(bf,thresh);
        elseif gradnorm==1
            bwframe=imbinarize(bf,'adaptive','ForegroundPolarity','dark','Sensitivity',thresh);
        end
        
        %subtract the constructed background from the current image
        sbwframe=bwframe-nmbwbkfrm;
        %         %%%NO BACKGROUND SUBTRACT
        %          sbwframe=bwframe;
        %         %%%end
        %take the absolute value of sbwframe then subtract sbwframe again
        %to garner the true image.  This prevents artifacts from the
        %background from "leaking" onto the image to be analyzed
        abwframe=abs(sbwframe)-sbwframe;
        %abwframe = ~sbwframe;
        %whitewash everything that isn't within the region of interest
        rbwframe=abwframe.*roi;
        
        origframe = rbwframe;
        %%%meannum ratio mean and min size
        meannum = 3;
        
        
        iteration = 1;
        count =0;
        DOUBLE = 0;
        keepXY = 0;
        Divider = 0;
        while OKFlag == 0
            
            count = count +1;
            if (thresh-.07-count/50 <=0)
                count = 7;
                rbwframe = origframe;
            end
            if (count > 6)
                Divider = 1;
                rbwframe = origframe;
            else
                Divider = count;
            end
            %determine number of connected objects
            cc=bwconncomp(rbwframe);
            %get how many connected pixels are in each object
            numPixels=cellfun(@numel,cc.PixelIdxList);
            % screen objects based upon minimum fly size
            
            while numel(numPixels) > numflies *2
                cc.PixelIdxList = cc.PixelIdxList(numPixels>median(numPixels));
                numPixels = numPixels(numPixels>median(numPixels));
            end
            
            BigObs = find(numPixels > (mean(numPixels)/meannum));%mean(numPixels)/(meannum));
            % the number of observed flies is assumed to be all objects bigger
            % than the minimum fly size
            
            
            obflies = numel(BigObs);
            
            if obflies~=numflies
                1;
            end
            
            
            if isempty(numPixels);
                numPixels=0;
            end
            
            if obflies == 0
                OKFlag = 1;
                output(2:end,currentframe) = nan;
                rbwframe = origframe;
                cc=bwconncomp(rbwframe);
                %get how many connected pixels are in each object
                numPixels=cellfun(@numel,cc.PixelIdxList);
                % screen objects based upon minimum fly size
                BigObs = find(numPixels > (mean(numPixels)/meannum));%mean(numPixels)/(meannum));
                % the number of observed flies is assumed to be all objects bigger
                % than the minimum fly size
                obflies = numel(BigObs);
                FliesToConsider = obflies;
                break;
            end
            
            % all this DualFly stuff was meant to determine when two flies are
            % so close in the image that they are actually shown to be touching
            % and so they only show up as one object.  This code was supposed
            % to account for that but never really came to fruition
            if (obflies < numflies)
                
                
                numPixels1 = numPixels;
                big1 = find(numPixels1 == max(numPixels1));
                numPixels1(big1) = 0;
                big2 = find(numPixels1 == max(numPixels1));
                numPixels1(big2) = 0;
                big3 = find(numPixels1 == max(numPixels1));
                
                if (numel(big1) > 1)
                    big2 = big1(2);
                    big1 = big1(1);
                    
                end
                
                if (numel(big2) >1)
                    big3 = big2(2);
                    big2 = big2(1);
                end
                
                if (numel(big3) >1)
                    big3 = big3(1);
                end
                
                try
                    Xleft1 = min(cc.PixelIdxList{big1})/VidHeight;
                catch
                    stop =1;
                end
                Xright1 = max(cc.PixelIdxList{big1})/VidHeight;
                remIdx1 =rem((cc.PixelIdxList{big1}),VidHeight);
                Ymin1 = min(remIdx1);
                Ymax1 = max(remIdx1);
                
                Xleft2 = min(cc.PixelIdxList{big2})/VidHeight;
                Xright2 = max(cc.PixelIdxList{big2})/VidHeight;
                remIdx2 = rem((cc.PixelIdxList{big2}),VidHeight);
                Ymin2 = min(remIdx2);
                Ymax2 = max(remIdx2);
                
                Xleft3 = min(cc.PixelIdxList{big3})/VidHeight;
                Xright3 = max(cc.PixelIdxList{big3})/VidHeight;
                remIdx3 = rem((cc.PixelIdxList{big3}),VidHeight);
                Ymin3 = min(remIdx3);
                Ymax3 = max(remIdx3);
                
                Xleft1 = floor(Xleft1) -count;
                if Xleft1<1
                    Xleft1 =1;
                end
                Xright1 = ceil(Xright1) +count;
                if Xright1>size(bwframe,2)
                    Xright1 = size(bwframe,2);
                end
                Ymin1 = floor(Ymin1) - count;
                if Ymin1 < 1
                    Ymin1 =1;
                end
                Ymax1 = ceil(Ymax1) + count;
                if Ymax1 > size(bwframe,1)
                    Ymax1 = size(bwframe,1);
                end
                
                Xleft2 = floor(Xleft2) - count;
                if Xleft2<1
                    Xleft2 =1;
                end
                Xright2 = ceil(Xright2) + count;
                if Xright2>size(bwframe,2)
                    Xright2 = size(bwframe,2);
                end
                Ymin2 = floor(Ymin2) - count;
                if Ymin2 < 1
                    Ymin2 =1;
                end
                Ymax2 = ceil(Ymax2) + count;
                 if Ymax2 > size(bwframe,1)
                    Ymax2 = size(bwframe,1);
                 end
                
                Xleft3 = floor(Xleft3) - count;
                if Xleft3<1
                    Xleft3 =1;
                end
                Xright3 = ceil(Xright3) + count;
                if Xright3>size(bwframe,2)
                    Xright3 = size(bwframe,2);
                end
                Ymin3 = floor(Ymin3) - count;
                if Ymin2 < 1
                    Ymin2 =1;
                end
                Ymax3 = ceil(Ymax3) + count;
                 if Ymax3 > size(bwframe,1)
                    Ymax3 = size(bwframe,1);
                end
                
                
                STATS1 = regionprops(rbwframe(Ymin1:Ymax1,Xleft1:Xright1,:),'MajorAxisLength','MinorAxisLength');
                STATS2 = regionprops(rbwframe(Ymin2:Ymax2,Xleft2:Xright2,:),'MajorAxisLength','MinorAxisLength');
                STATS3 = regionprops(rbwframe(Ymin3:Ymax3,Xleft3:Xright3,:),'MajorAxisLength','MinorAxisLength');
                
                if numel(STATS1) > 1
                    holdmajor = max(STATS1.MajorAxisLength);
                    holdminor = max(STATS1.MinorAxisLength);
                    STATS1 = struct('MajorAxisLength',holdmajor,'MinorAxisLength',holdminor);
                end
                if numel(STATS2) > 1
                    holdmajor = max(STATS2.MajorAxisLength);
                    holdminor = max(STATS2.MinorAxisLength);
                    STATS2 = struct('MajorAxisLength',holdmajor,'MinorAxisLength',holdminor);
                end
                if numel(STATS3) > 1
                    holdmajor = max(STATS3.MajorAxisLength);
                    holdminor = max(STATS3.MinorAxisLength);
                    STATS3 = struct('MajorAxisLength',holdmajor,'MinorAxisLength',holdminor);
                end
                
                % the value of 1.5 is arbitrary based upon looking at
                % thresholded images
                if (STATS1.MajorAxisLength / STATS3.MajorAxisLength > 1.5)
                    AxisBonus11 = .04;
                    DOUBLE = 1;
                else
                    AxisBonus11 = 0;
                end
                if (STATS2.MajorAxisLength / STATS3.MajorAxisLength > 1.5)
                    AxisBonus21 = .04;
                    DOUBLE = 1;
                else
                    AxisBonus21 = 0;
                end
                if (STATS1.MinorAxisLength / STATS3.MinorAxisLength > 1.5)
                    AxisBonus12 = .04;
                    DOUBLE = 1;
                else
                    AxisBonus12 = 0;
                end
                
                if (STATS2.MinorAxisLength / STATS3.MinorAxisLength > 1.5)
                    AxisBonus22 = .04;
                    DOUBLE = 1;
                else
                    AxisBonus22 = 0;
                end
                if (AxisBonus11 == AxisBonus12)
                    AxisBonus12 = 0;
                end
                if (AxisBonus21 == AxisBonus22)
                    AxisBonus22 = 0;
                end
                
                if currentframe>2000
                    stop=1;
                end
                
                zoomframe1 = frames(Ymin1:Ymax1,Xleft1:Xright1,:,j-sJ+1);
                zoomframe2 = frames(Ymin2:Ymax2,Xleft2:Xright2,:,j-sJ+1);
                
                
%                 zbwframe1 = im2bw(zoomframe1,thresh-(AxisBonus11+AxisBonus12+Divider/100));
%                 zbwframe2 = im2bw(zoomframe2,thresh-(AxisBonus21+AxisBonus22+Divider/100));
                
                rzf1=rgb2gray(zoomframe1);
                rzf2=rgb2gray(zoomframe2);
                if gradnorm==0
                    zbwframe1=imbinarize(rzf1,thresh-(AxisBonus11+AxisBonus12+Divider/100));
                    zbwframe2=imbinarize(rzf2,thresh-(AxisBonus21+AxisBonus22+Divider/100));
                elseif gradnorm==1
                    zbwframe1=imbinarize(rzf1,'adaptive','ForegroundPolarity','dark','Sensitivity',thresh-(AxisBonus11+AxisBonus12+Divider/100));
                    zbwframe2=imbinarize(rzf2,'adaptive','ForegroundPolarity','dark','Sensitivity',thresh-(AxisBonus21+AxisBonus22+Divider/100));
                end
                
                
                
                bf=rgb2gray(frames(:,:,:,j-sJ+1));
                if gradnorm==0
                    bwframe=imbinarize(bf,thresh);
                elseif gradnorm==1
                    bwframe=imbinarize(bf,'adaptive','ForegroundPolarity','dark','Sensitivity',thresh);
                end
                
                %bwframe=im2bw(frames(:,:,:,j),thresh);%-Divider/100);
                
                bwframe(Ymin1:Ymax1,Xleft1:Xright1,:) = zbwframe1;
                bwframe(Ymin2:Ymax2,Xleft2:Xright2,:) = zbwframe2;
                sbwframe=bwframe-nmbwbkfrm;
                abwframe=abs(sbwframe)-sbwframe;
                %abwframe = ~sbwframe;
                %whitewash everything that isn't within the region of interest
                rbwframe=abwframe.*roi;
                
%                 abwframe=1-bwframe;
%                 rbwframe=abwframe.*roi;
                
                aa = bwconncomp(1-zbwframe1);
                bb = bwconncomp(1-zbwframe2);
                
                numPixels1=cellfun(@numel,aa.PixelIdxList);
                BigObs1 = find(numPixels1 > (mean(numPixels)/meannum));
                obflies1 = numel(BigObs1);
                
                numPixels2=cellfun(@numel,bb.PixelIdxList);
                BigObs2 = find(numPixels2 > (mean(numPixels)/meannum));
                obflies2 = numel(BigObs2);
                
                if AxisBonus11 > 0 || AxisBonus12 > 0 || AxisBonus21 > 0 || AxisBonus22 > 0
                    ErrorRate(1,currentframe) = 1;
                    if obflies1 > 1 || obflies2 > 1
                        ErrorRate(2,currentframe)= 1;
                    else
                        ErrorRate(2,currentframe)= 0;
                    end
                else
                    ErrorRate(1,currentframe) = 0;
                end
                
                if (numflies - obflies) ==1
                    if AxisBonus11 > 0 || AxisBonus12 > 0 || AxisBonus21 > 0 || AxisBonus22 > 0
                        ErrorRate(4,currentframe) = 1;
                        if obflies1 > 1 || obflies2 > 1
                            ErrorRate(5,currentframe)= 1;
                        else
                            ErrorRate(5,currentframe)= 0;
                        end
                    else
                        ErrorRate(4,currentframe) = 0;
                    end
                end
                
            else
                OKFlag =1;
                FliesToConsider = obflies;
                obflies1 = 200;
            end
            
            if obflies >= numflies %how many possible flies are observed?
                FliesToConsider = obflies;
                obflies = numflies;
                OKFlag =1;
            end
            
            
            %determine number of connected objects
            cc=bwconncomp(rbwframe);
            %get how many connected pixels are in each object
            numPixels=cellfun(@numel,cc.PixelIdxList);
            % screen objects based upon minimum fly size
            while numel(numPixels) > numflies *2
                cc.PixelIdxList = cc.PixelIdxList(numPixels>median(numPixels));
                numPixels = numPixels(numPixels>median(numPixels));
            end
            
            BigObs = find(numPixels > (mean(numPixels)/meannum));%mean(numPixels)/(meannum));
            % the number of observed flies is assumed to be all objects bigger
            % than the minimum fly size
            
            obflies = numel(BigObs);
            
            if obflies~=numflies
                1;
            end
            
            
            if isempty(numPixels);
                numPixels=0;
            end
            
            FliesToConsider = obflies;
            
            
            if (obflies == numflies) && (obflies1 > 1 || obflies2 > 1)
                FliesToConsider = obflies;
                OKFlag = 1;
                
            else
                rbwframe=origframe;
                if FliesToConsider < numflies
                    
                    
                    
                    
                    MajorUsed1 = 0;
                    MajorUsed2 = 0;
                    if (STATS1.MajorAxisLength / STATS3.MajorAxisLength > 1.5)
                        if (Ymax1-Ymin1) > (Xright1-Xleft1)
                            rbwframe(floor(Ymin1+(Ymax1-Ymin1)/2),Xleft1:Xright1,:) =0;
                        else
                            rbwframe(Ymin1:Ymax1,floor(Xleft1+(Xright1-Xleft1)/2),:) =0;
                        end
                        MajorUsed1 = 1;
                    end
                    if (STATS2.MajorAxisLength / STATS3.MajorAxisLength > 1.5)
                        if (Ymax2-Ymin2) > (Xright2-Xleft2)
                            rbwframe(floor(Ymin2+(Ymax2-Ymin2)/2),Xleft2:Xright2,:) =0;
                        else
                            rbwframe(Ymin2:Ymax2,floor(Xleft2+(Xright2-Xleft2)/2),:) =0;
                        end
                        MajorUsed2=1;
                    end
                    if (STATS1.MinorAxisLength / STATS3.MinorAxisLength > 1.5)
                        if ~MajorUsed1
                            if (Ymax1-Ymin1) > (Xright1-Xleft1)
                                rbwframe(floor(Ymin1+(Ymax1-Ymin1)/2),Xleft1:Xright1,:) =0;
                            else
                                rbwframe(Ymin1:Ymax1,floor(Xleft1+(Xright1-Xleft1)/2),:) =0;
                            end
                        end
                    end
                    
                    if (STATS2.MinorAxisLength / STATS3.MinorAxisLength > 1.5)
                        if ~MajorUsed2
                            if (Ymax2-Ymin2) > (Xright2-Xleft2)
                                bwframe(floor(Ymin2+(Ymax2-Ymin2)/2),Xleft2:Xright2,:) =0;
                            else
                                bwframe(Ymin2:Ymax2,floor(Xleft2+(Xright2-Xleft2)/2),:) =0;
                            end
                        end
                    end
                    
                    
                    %determine number of connected objects
                    cc=bwconncomp(rbwframe);
                    %get how many connected pixels are in each object
                    numPixels=cellfun(@numel,cc.PixelIdxList);
                    % screen objects based upon minimum fly size
                    while numel(numPixels) > numflies *2
                        cc.PixelIdxList = cc.PixelIdxList(numPixels>median(numPixels));
                        numPixels = numPixels(numPixels>median(numPixels));
                    end
                    BigObs = find(numPixels > (mean(numPixels)/meannum));%mean(numPixels)/(meannum));
                    % the number of observed flies is assumed to be all objects bigger
                    % than the minimum fly size
                    
                    obflies = numel(BigObs);
                    FliesToConsider = obflies;
                    
                    
                    
                    
                    
                    
                end
                OKFlag = 1;
            end
            % end
            if FliesToConsider > numflies
                stop =1;
            end
            output(1,currentframe)=currentframe; % mark frame number
            UsedFlyArray = zeros(1,numflies);
            if (keepXY == 1)
                if FliesToConsider == numflies
                    
                end
            else
                XYArray = zeros(1,FliesToConsider*2);
                dist = zeros(1,FliesToConsider)+1000;
                for k = 1:FliesToConsider % get X and Y or all possible flies
                    [v idx]=max(numPixels);
                    % Heuristic method to generate X coord
                    Xleft = min(cc.PixelIdxList{idx})/VidHeight;
                    Xright = max(cc.PixelIdxList{idx})/VidHeight;
                    Xcoord = (Xleft+Xright)/2;
                    % Heuristic method to generate Y coord
                    remIdx =rem((cc.PixelIdxList{idx}),VidHeight);
                    Ymin = min(remIdx);
                    Ymax = max(remIdx);
                    Ycoord = ((Ymin+Ymax)/2);
                    
                    
                    
                    XYArray(k*2-1) = Xcoord;
                    XYArray(k*2) = Ycoord;
                    
                    
                    
                    numPixels(idx)=0;
                end
            end
            try
                prevoutput=output(:,currentframe-1);
                if sum(isnan(prevoutput))>0
                    stop = 1;
                    prev_i=1;
                    while prev_i>0
                        prevoutput(isnan(prevoutput))=output(isnan(prevoutput),currentframe-(prev_i+1));
                        if sum(isnan(prevoutput))>0
                            prev_i = prev_i+1;
                        else
                            prev_i = 0;
                        end
                    end
                end
                
%                 while isnan(prevoutput(2))
%                     prev_i=prev_i+1;
%                     prevoutput=output(:,currentframe-prev_i);
%                     md=2.5*md;
%                 end
            catch
                if exist('prevoutput')==0
                    
                    prevoutput = output(:,1);
                end
                if prevoutput(1)<sFrame
                    for jj =1:numflies
                        prevoutput(jj*2)= InitCoords(jj,1);
                        output(jj*2,prevoutput(1))= InitCoords(jj,1);
                        prevoutput(jj*2+1)= InitCoords(jj,2);
                        output(jj*2+1,prevoutput(1))= InitCoords(jj,2);
                    end
                else
                    prevoutput = output(:,1);
                end
            end
            
            if DOUBLE == 1
                dobflies = obflies + 1;
                if dobflies > numflies
                    dobflies = numflies;
                end
            else
                dobflies = obflies;
            end
            
            if obflies >= numflies %how many possible flies are observed?
                obflies = numflies;
            end
            
            if dobflies >= numflies %how many possible flies are observed?
                dobflies = numflies;
            end
            
            dist = zeros(dobflies,FliesToConsider)+1000;
            RepeatedPoint=0;
            
            for k=1:numflies % for the number of flies observed in the picture
                
                % this was a check of the initial coordinates the user inputs
                % versus what the program found although the warning message
                % has since been turned off
                if currentframe==startFrame
                    XOK = 0;
                    YOK = 0;
                    XOK = find(abs(InitCoords(:,1) - Xcoord) < 20);
                    YOK = find(abs(InitCoords(:,2) - Ycoord) < 20);
                    %                 if( isempty(XOK) && isempty(YOK))
                    %                     msgbox('Entered First Coordinates Did NOT match computed first coordinates. This run may produce erroneous results','Warning!','warn');
                    %                 end
                    try
                        output(k*2,currentframe)=XYArray(k*2-1);
                        output(k*2+1,currentframe)=XYArray(k*2);
                    catch
                        for x=1:numflies
                            output(x*2,currentframe)= InitCoords(x,1);
                            output(x*2+1,currentframe)= InitCoords(x,2);
                        end
                        disp('User initiated first coordinates');
                    end
                    
                    BigPixels=cellfun(@numel,cc.PixelIdxList); %this block will adjust the fly size so that
                    BiggestFly=max(BigPixels); % videos taken at different depths or resolutions will adjust to how many
                    FlySize = BiggestFly / 10; %pixels the flies are instead of just setting a number arbitrarily
                    BiggestPossibleFly = BiggestFly * 1.15; % this was an arbitrary method that I made up (can be improved)
                    
                    for l=1:FliesToConsider
                        
                        dist(k,l)=sqrt((XYArray(l*2-1)-InitCoords(k,1))^2+(XYArray(l*2)-InitCoords(k,2))^2);
                    end
                    
                    
                end
                if currentframe ~= startFrame
                    
                    
                    if obflies >= numflies %how many possible flies are observed?
                        obflies = numflies;
                    end
                    
                    for l=1:FliesToConsider
                        % generate distance matrix to each fly from previous
                        % position
                        dist(k,l)=sqrt((XYArray(l*2-1)-prevoutput(k*2))^2+(XYArray(l*2)-prevoutput(k*2+1))^2);
                    end
                    
                end
            end
            
            
            if currentframe ~= 0
                
                
                if (currentframe > 45 && numel(find(dist < 10))>numflies)
                    deltaXY  = (output(:,currentframe-1)-output(:,currentframe-5))./5;
                    predictedXY = output(:,currentframe-1) + (deltaXY);
                    for q=1:numflies
                        for kk = 1:FliesToConsider
                            dist(q,kk)=sqrt((XYArray(kk*2-1)-predictedXY(q*2))^2+(XYArray(kk*2)-predictedXY(q*2+1))^2);
                        end
                    end
                    
                end
                
                for q=1:numflies
                    UsedMarker = 0;
                    count=0;
                    while (UsedMarker == 0)
                        
                        if count >= FliesToConsider
                            UsedMarker = 1;
                        end
                        %use the minimum distance to assume that fly moves
                        %md=60;
                        
                        try
                            minval = min(min(dist));
                            
                            [DetectedOld DetectedNew] = find(dist == minval);
                            if isempty(DetectedOld)
                                DetectedOld
                            end
                            DetectedOld = DetectedOld(1);
                            DetectedNew = DetectedNew(1);
                        catch
                            aaaa=1;
                        end
                        if (UsedFlyArray(DetectedOld(1)) == 0)
                            
                            
                            if(minval < md+45*RepeatedPoint)
                                output(DetectedOld*2,currentframe) = XYArray(DetectedNew*2-1);
                                output(DetectedOld*2+1,currentframe) = XYArray(DetectedNew*2);
                                UsedFlyArray(DetectedOld) = 1;
                                dist(:,DetectedNew) = 10000;
                            else
                                stop = 1;
                            end
                            UsedMarker = 1;
                        else
                            dist(DetectedOld,DetectedNew) = 1000;
                            count = count + 1;
                            
                        end
                    end
                end
            end
            
            
            
            
            
            for k=1:numflies
                
                
                
                
                if(isnan(output(k*2,currentframe)) && DOUBLE)
                    try
                        for l=1:obflies
                            dist2(l)=sqrt((XYArray(l*2-1)-prevoutput(k*2))^2+(XYArray(l*2)-prevoutput(k*2+1))^2);
                        end
                        
                        DoubledPoint = find(dist2 == min(dist2));
                        DoubledPoint = DoubledPoint(1);
                        output(k*2,currentframe)=XYArray(DoubledPoint*2-1);
                        output(k*2+1,currentframe)=XYArray(DoubledPoint*2);
                    end
                    clear dist2
                    RepeatedPoint1(k) = 1;
                else
                    RepeatedPoint1(k) = 0;
                end
                
                if(isnan(output(k*2,currentframe)))

                        
                    try
                        output(k*2,currentframe)=output(k*2,currentframe-1);
                    catch
                        output(k*2,currentframe)= 0;
                    end
                    RepeatedPoint2(k) = 1;

                else
                    RepeatedPoint2(k) = 0;
                end
                if(isnan(output(k*2+1,currentframe)))
                    try
                        output(k*2+1,currentframe)=output(k*2+1,currentframe-1);
                    catch
                        output(k*2+1,currentframe)=0;
                    end
                end
                
                if ~isnan(output(k*2,currentframe))
                    
                    if oroi(round(output(k*2+1,currentframe)),round(output(k*2,currentframe)),flyroi(k))==0
                        currentframe;
                        if isChoiceAssay==0
                            output(k*2,currentframe)=nan;
                            output(k*2+1,currentframe)=nan;
                        else
                            currentframe;
                            
                        end
                        
                    end
                    
                else
                    output(k*2,currentframe)=nan;
                    output(k*2+1,currentframe)=nan;
                end
                
                
                
            end
            if(sum(RepeatedPoint1)>0 || sum(RepeatedPoint2)>0);
                RepeatedPoint = RepeatedPoint+1;
                ErrorRate(3,currentframe) = 1;
            else
                RepeatedPoint = 0;
            end
            
%             if exist('xyz')==0
%                 xyz = figure;
%             elseif mod(currentframe,30)==0
%                 figure(xyz)
%             end
%             if mod(currentframe,30)==0
%                 imshow(rbwframe);
%                 hold on
%                 for k=1:numflies
%                     
%                     plot(output(k*2,:),output(k*2+1,:),'-');
%                     plot(output(k*2,currentframe),output(k*2+1,currentframe),'x');
%                 end
%                 hold off
%                 title([{[FILE]};{['Frame = ',num2str(currentframe)]}])
%             end
        end
        catch ME
            disp(['error with fr#',num2str(currentframe)]);
            disp(ME)
        end
        
            
    end
    %   toc;
end
close(h)

abc=output;








