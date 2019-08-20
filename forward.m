function coordinating=forward(a1,b1)
a=(rgb2gray(a1));
b=(rgb2gray(b1));
% c=a-b;
% figure,imshow(c);
%% Preprocessing
[r1,c1]=size(a);
blockSizeR=r1/4;
blockSizeC=c1/5;
coordinates=[];
coor=zeros(256,320);
for rowi = 1 : blockSizeR : r1
    for coli = 1 : blockSizeC : c1
        row1 = rowi;
        row2 = row1 + blockSizeR - 1;
        col1 = coli;
        col2 = col1 + blockSizeC - 1;
        % Extract out the block into a single subimage.
        mainimage = a(row1:row2, col1:col2);
        referenceimage = b(row1:row2, col1:col2);
        for k=1:8:length(mainimage)
            for l=1:8:length(referenceimage)
                ro1=k;
                ro2=ro1+7;
                co1=l;
                co2=co1+7;
                mainpatch=mainimage(ro1:ro2,co1:co2);
                referencepatch=referenceimage(ro1:ro2,co1:co2);
                Mv1=mainpatch(3:4,3:4);
                Mv2=mainpatch(4,5);
                Mv3=mainpatch(4,6);
                Mv4=mainpatch(4,7:8);
                Mv5=mainpatch(5:8,3:4);
                Mv6=mainpatch(5:6,7:8);
                Mv7=mainpatch(7:8,7:8);
                MV1=referencepatch(3:4,3:4);
                MV2=referencepatch(4,5);
                MV3=referencepatch(4,6);
                MV4=referencepatch(4,7:8);
                MV5=referencepatch(5:8,3:4);
                MV6=referencepatch(5:6,7:8);
                MV7=referencepatch(7:8,7:8);
                M1=floor((sum(sum(Mv1-MV1)))/9);
                M2=floor((sum(sum(Mv2-MV2)))/9);
                M3=floor((sum(sum(Mv3-MV3)))/9);
                M4=floor((sum(sum(Mv4-MV4)))/9);
                M5=floor((sum(sum(Mv5-MV5)))/9);
                M6=floor((sum(sum(Mv6-MV6)))/9);
                M7=floor((sum(sum(Mv7-MV7)))/9);
                Motionvector=[M1 M2 M3 M4 M5 M6 M7];
                num=nnz(Motionvector);
                M=Motionvector(Motionvector~=0);
                R = spones(Motionvector);
                if num~=0
                    ind=find(R==1);
                else
                    ind=[];
                end
                zz=[];
                if ~isempty(ind)
                    for i=1:length(ind)
                        in1=ind(i);
                        %                         in2=0;
                        %                         in3=0;
                        if i~=length(ind)
                            in2=ind(i+1);
                        else
                            in2=ind(1);
                            if in2==1
                                in2=2;
                            end
                        end
                        if i~=1
                            in3=ind(i-1);
                        else
                            in3=ind(length(ind));
                            if in3==7
                                in3=6;
                            end
                        end
                        if (in1==(in2-1))||(in1==(in3+1))
                            zz=[zz in1];
                        end
                    end
                end
                %                 RGB = insertShape(b1,'rectangle',[coli-1+l rowi-1+k  8 8],'LineWidth',1);
                %                 imshow(RGB);
                if length(zz)>2 && (M1==0 || M2==0 || M3==0 || M4==0 || M5==0 || M6==0 || M7==0)
                    %                     RGB = insertShape(b1,'rectangle',[coli-1+l rowi-1+k 8 8],'LineWidth',1);
                    %pause(1);
                    coordinates=[coli-1+l rowi-1+k 8 8; coordinates];
                    coor(rowi-1+k,coli-1+l)=1;
                    
                    %                     drawnow;
                end
            end
        end
        
    end
    
end

[ssx,ssy]=find(coor==1);
coordinating=[];
for i=1:length(ssx)
    x=ssx(i);
    y=ssy(i);
    z=0;
    if x<246
        x1x=x+8;
        x1y=y;
        if coor(x,y)==coor(x1x,x1y)
            z=z+1;
        end
    else
        z=z+0;
    end
    if x>9
        x3x=x-8;
        x3y=y;
        if coor(x,y)==coor(x3x,x3y)
            z=z+1;
        end
    else
        z=z+0;
    end
    if y<310
        x2x=x;
        x2y=y+8;
        if coor(x,y)==coor(x2x,x2y)
            z=z+1;
        end
    else
        z=z+0;
    end
    if y>9
        x4x=x;
        x4y=y-8;
        if coor(x,y)==coor(x4x,x4y)
            z=z+1;
        end
    else
        z=z+0;
    end
    if z>1
        coordinating=[coordinating;y x 8 8];
    end
end
% RGB = insertShape(a1,'rectangle',coordinating,'LineWidth',1);
% figure;
% imshow(RGB);