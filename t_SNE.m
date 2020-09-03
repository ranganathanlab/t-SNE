annotation=load('Input/annotation.mat').annotationvF;
msa=fastaread('Input/fungi_59.fasta'); % Sho1 is No. 1194; header ID 1277
re=load('Input/re.mat').re;
v_traj_onehot=load('Input/onehot.mat').v_traj_onehot;
v_traj_onehot=double(v_traj_onehot);

msaheader=zeros(numel(msa),1);
for i=1:numel(msa)
tmp=str2double(msa(i).Header(5:end));
msaheader(i)=tmp+1;
end
re=re(msaheader);
re(isinf(re))=nan;

% color for RE scattering
c = re;
c=10*(re+2.63)/(2.63-0.573);
c(re>=-0.573)=10;
c(re<=-2.63)=0;

X_tsne = tsne(v_traj_onehot);

% RE scatter
figure(1);
hold on 
all = scatter(X_tsne(:,1),X_tsne(:,2), 20, c,'filled');
sho1s = scatter(X_tsne(1194,1),X_tsne(1194,2), 40, 'red','filled','DisplayName','Sho1');
legend(sho1s);
xlabel('t-SNE 1');
ylabel('t-SNE 2');
colorbar('XTickLabel',linspace(-2.63,-0.573,10),'XTick',linspace(0,10,10));
hold off

proteins = ["Drebrins and related actin binding proteins",
 "Cdc42-interacting protein CIP4",
 "Ras1 guanine nucleotide exchange factor",
 "NADPH oxidase",
 "Amphiphysin",
 "Adaptor protein NCK/Dock, contains SH2 and SH3 domains",
 "Adaptor protein GRB2, contains SH2 and SH3 domains",
 "Myosin class I heavy chain",
 "Uncharacterized conserved protein",
 "Predicted proline-serine-threonine phosphatase-interacting protein (PSTPIP)"];

pro_group=strings(numel(msa),1);
l=zeros(numel(msa),1);
for i=1:numel(msa)
    for j=1:10
        if annotation(msaheader(i),'Protein').Protein==proteins(j)
            pro_group(i)=proteins(j);
            l(i)=1;
            break
        end
    end
end

% protein scatter
figure(2);
gscatter(X_tsne(l==1,1),X_tsne(l==1,2), pro_group(l==1));
%legend('Functions')
%sho1s = scatter(X_tsne(1194,1),X_tsne(1194,2), 40, 'red','filled','DisplayName','Sho1');
xlabel('t-SNE 1');
ylabel('t-SNE 2');

% phylogeny scatter
phylogen = ["Saccharomycotina", "Basidiomycota", "Pezizomycotina"];
phy_group=strings(numel(msa),1);
for i=1:numel(phy_group)
    phy_group(i)="Non-Dikarya";
end
for i=1:numel(msa)
    for j=1:3
        if contains(char(annotation(msaheader(i),'Phylogeny').Phylogeny),phylogen(j))
            phy_group(i)=phylogen(j);
            break
        end
    end
end

% Phylogeny scatter
figure(3);
gscatter(X_tsne(:,1),X_tsne(:,2), phy_group);
%legend('Functions')
%sho1s = scatter(X_tsne(1194,1),X_tsne(1194,2), 40, 'red','filled','DisplayName','Sho1');
xlabel('t-SNE 1');
ylabel('t-SNE 2');

% phylogeny & function
figure(4);
gscatter(X_tsne(l==1,1),X_tsne(l==1,2), pro_group(l==1),'rgbcmykrgb','hdsp');
%legend('Functions')
%sho1s = scatter(X_tsne(1194,1),X_tsne(1194,2), 40, 'red','filled','DisplayName','Sho1');
xlabel('t-SNE 1');
ylabel('t-SNE 2'); 