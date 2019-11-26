function abc=plotheatmap(Coordinates,NumberOfFlies,Xscale,Yscale,FirstFrame,FramesPerSecond)
Resolution=0.5;
LogScale=1;
SC(1,:)=Coordinates(1,:);
for i=1:NumberOfFlies
    SC(i*2,:)=Coordinates(i*2,:)*Xscale;
    SC(i*2+1,:)=Coordinates(i*2+1,:)*Yscale;
end
rSC=round(SC/Resolution)*Resolution;
Xe=[0:Resolution:round(size(FirstFrame,2)*Xscale*Resolution)/Resolution];
Ye=[0:Resolution:round(size(FirstFrame,1)*Yscale*Resolution)/Resolution];
Tmin=1;
if Tmin<1
    Tmin=1;
    set(handles.frame_min_edit,'String',num2str(1));
end
Tmax=size(Coordinates,2);
if Tmax>size(Coordinates,2)
    Tmax=size(Coordinates,2);
    set(handles.frame_max_edit,'String',num2str(size(Coordinates,2)));
end
for i=1:NumberOfFlies
    [N(:,:,i) X Y]=histcounts2(rSC(i*2,Tmin:Tmax),rSC(i*2+1,Tmin:Tmax),Xe,Ye);
end
sN=sum(N,3)*1/FramesPerSecond;
if LogScale==1
    sN=log10(sN);
end
abc.Xe=Xe;
abc.Ye=Ye;
abc.sN=sN';

end