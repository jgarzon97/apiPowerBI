PGDMP         3                |            dwcamaronera    15.7    15.7 %    ;           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            <           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            =           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            >           1262    43053    dwcamaronera    DATABASE        CREATE DATABASE dwcamaronera WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE dwcamaronera;
                postgres    false            �            1259    43054    canton    TABLE     n   CREATE TABLE public.canton (
    can_cod double precision,
    can_nom text,
    prov_cod double precision
);
    DROP TABLE public.canton;
       public         heap    postgres    false            �            1259    43060    corrida    TABLE     �   CREATE TABLE public.corrida (
    cor_cod double precision,
    cor_fec_ini timestamp without time zone,
    cor_fec_fin timestamp without time zone,
    cor_est text,
    "año" double precision,
    mes_codigo double precision
);
    DROP TABLE public.corrida;
       public         heap    postgres    false            �            1259    43072    corrida_piscina    TABLE     �   CREATE TABLE public.corrida_piscina (
    cp_num_larv double precision,
    cp_cos_inv double precision,
    cp_total_ing double precision,
    emp_cod double precision,
    pis_cod double precision,
    cor_cod double precision
);
 #   DROP TABLE public.corrida_piscina;
       public         heap    postgres    false            �            1259    43100    cosecha    TABLE     �   CREATE TABLE public.cosecha (
    cos_cant_kg double precision,
    cos_pre_kg double precision,
    cos_ing double precision,
    cor_cod double precision,
    pis_cod double precision,
    tal_cod double precision,
    emp_cod double precision
);
    DROP TABLE public.cosecha;
       public         heap    postgres    false            �            1259    43094    empresa    TABLE     �   CREATE TABLE public.empresa (
    emp_cod double precision,
    emp_nom text,
    emp_nom_cam text,
    pais_cod double precision,
    prov_cod double precision,
    can_cod double precision
);
    DROP TABLE public.empresa;
       public         heap    postgres    false            �            1259    43076    mes    TABLE     r   CREATE TABLE public.mes (
    mes_codigo double precision,
    mes text,
    trimestre text,
    semestre text
);
    DROP TABLE public.mes;
       public         heap    postgres    false            �            1259    43088    pais    TABLE     O   CREATE TABLE public.pais (
    pais_cod double precision,
    pais_nom text
);
    DROP TABLE public.pais;
       public         heap    postgres    false            �            1259    43066    piscina    TABLE     �   CREATE TABLE public.piscina (
    pis_cod double precision,
    pis_nom text,
    pis_num_hect double precision,
    emp_cod double precision
);
    DROP TABLE public.piscina;
       public         heap    postgres    false            �            1259    43082 	   provincia    TABLE     s   CREATE TABLE public.provincia (
    prov_cod double precision,
    prov_nom text,
    pais_cod double precision
);
    DROP TABLE public.provincia;
       public         heap    postgres    false            �            1259    43104    talla    TABLE     f   CREATE TABLE public.talla (
    tall_cod double precision,
    tall_nombre text,
    tall_cam text
);
    DROP TABLE public.talla;
       public         heap    postgres    false            �            1259    43110 
   vi_Piscina    VIEW       CREATE VIEW public."vi_Piscina" AS
 SELECT pi.pis_cod,
    e.emp_nom AS empresa,
    e.emp_nom_cam AS camaronera,
    pa.pais_nom AS pais,
    pr.prov_nom AS provincia,
    c.can_nom AS canton,
    pi.pis_nom AS piscina,
    pi.pis_num_hect AS hectareas
   FROM public.canton c,
    public.empresa e,
    public.pais pa,
    public.provincia pr,
    public.piscina pi
  WHERE ((c.can_cod = e.can_cod) AND (e.emp_cod = pi.emp_cod) AND (pa.pais_cod = e.pais_cod) AND (pr.prov_cod = e.prov_cod))
  ORDER BY e.emp_nom, pi.pis_nom;
    DROP VIEW public."vi_Piscina";
       public          postgres    false    216    216    216    219    219    220    220    221    221    221    221    221    221    214    214    216            �            1259    43114    vi_piscina_corrida    VIEW     �  CREATE VIEW public.vi_piscina_corrida AS
 SELECT pi.empresa,
    pi.camaronera,
    pi.pis_cod,
    pi.piscina,
    cr.cor_cod AS corrida,
    cr.cor_est AS estado,
    pi.pais,
    pi.provincia,
    pi.canton,
    cr."año" AS "Año",
    mes.semestre,
    mes.trimestre,
    mes.mes,
    cp.cp_num_larv AS "Num larvas",
    (cp.cp_num_larv / pi.hectareas) AS "Larvas por Hectarea",
    cp.cp_cos_inv AS "Costo de inversion",
    i.ingresos AS "Total ingresos",
    round(((i.ingresos - cp.cp_cos_inv))::numeric, 3) AS "Utilidad monto",
    round(((((i.ingresos - cp.cp_cos_inv) / cp.cp_cos_inv) * (100)::double precision))::numeric, 3) AS "Utilidad %"
   FROM public.mes mes,
    public."vi_Piscina" pi,
    public.corrida cr,
    public.corrida_piscina cp,
    ( SELECT c.pis_cod,
            c.cor_cod,
            sum((c.cos_cant_kg * c.cos_pre_kg)) AS ingresos
           FROM public.cosecha c
          GROUP BY c.emp_cod, c.pis_cod, c.cor_cod
          ORDER BY c.emp_cod, c.pis_cod, c.cor_cod) i
  WHERE ((mes.mes_codigo = cr.mes_codigo) AND (pi.pis_cod = cp.pis_cod) AND (cr.cor_cod = cp.cor_cod) AND (cp.pis_cod = i.pis_cod) AND (cp.cor_cod = i.cor_cod))
  ORDER BY pi.empresa, pi.piscina, cr.cor_cod;
 %   DROP VIEW public.vi_piscina_corrida;
       public          postgres    false    224    224    224    215    215    215    215    217    217    217    217    218    218    218    218    222    222    222    222    222    224    224    224    224    224            �            1259    43119 
   vi_corrida    VIEW     W  CREATE VIEW public.vi_corrida AS
 SELECT pc.empresa,
    pc.camaronera,
    pc.piscina,
    pc.corrida,
    pc.estado,
    pc.pais,
    pc.provincia,
    pc.canton,
    pc."Año",
    pc.semestre,
    pc.trimestre,
    pc.mes,
    t.tall_nombre AS "Talla",
    c.cos_cant_kg AS "Cantidad kg",
    c.cos_pre_kg AS "Precio kg",
    (c.cos_cant_kg * c.cos_pre_kg) AS "Total ingreso"
   FROM public.vi_piscina_corrida pc,
    public.talla t,
    public.cosecha c
  WHERE ((c.tal_cod = t.tall_cod) AND (c.pis_cod = pc.pis_cod) AND (c.cor_cod = pc.corrida))
  ORDER BY pc.empresa, pc.piscina, pc.corrida;
    DROP VIEW public.vi_corrida;
       public          postgres    false    222    225    225    225    225    225    225    225    225    225    225    225    225    225    223    223    222    222    222    222            /          0    43054    canton 
   TABLE DATA           <   COPY public.canton (can_cod, can_nom, prov_cod) FROM stdin;
    public          postgres    false    214   �1       0          0    43060    corrida 
   TABLE DATA           a   COPY public.corrida (cor_cod, cor_fec_ini, cor_fec_fin, cor_est, "año", mes_codigo) FROM stdin;
    public          postgres    false    215   "2       2          0    43072    corrida_piscina 
   TABLE DATA           k   COPY public.corrida_piscina (cp_num_larv, cp_cos_inv, cp_total_ing, emp_cod, pis_cod, cor_cod) FROM stdin;
    public          postgres    false    217   13       7          0    43100    cosecha 
   TABLE DATA           g   COPY public.cosecha (cos_cant_kg, cos_pre_kg, cos_ing, cor_cod, pis_cod, tal_cod, emp_cod) FROM stdin;
    public          postgres    false    222   5I       6          0    43094    empresa 
   TABLE DATA           ]   COPY public.empresa (emp_cod, emp_nom, emp_nom_cam, pais_cod, prov_cod, can_cod) FROM stdin;
    public          postgres    false    221   �]       3          0    43076    mes 
   TABLE DATA           C   COPY public.mes (mes_codigo, mes, trimestre, semestre) FROM stdin;
    public          postgres    false    218   *^       5          0    43088    pais 
   TABLE DATA           2   COPY public.pais (pais_cod, pais_nom) FROM stdin;
    public          postgres    false    220   �^       1          0    43066    piscina 
   TABLE DATA           J   COPY public.piscina (pis_cod, pis_nom, pis_num_hect, emp_cod) FROM stdin;
    public          postgres    false    216   �^       4          0    43082 	   provincia 
   TABLE DATA           A   COPY public.provincia (prov_cod, prov_nom, pais_cod) FROM stdin;
    public          postgres    false    219   �_       8          0    43104    talla 
   TABLE DATA           @   COPY public.talla (tall_cod, tall_nombre, tall_cam) FROM stdin;
    public          postgres    false    223    `       �           1259    43059    idx_canton_lookup    INDEX     Z   CREATE INDEX idx_canton_lookup ON public.canton USING btree (can_cod, can_nom, prov_cod);
 %   DROP INDEX public.idx_canton_lookup;
       public            postgres    false    214    214    214            �           1259    43065    idx_corrida_lookup    INDEX     �   CREATE INDEX idx_corrida_lookup ON public.corrida USING btree (cor_cod, cor_fec_ini, cor_fec_fin, cor_est, "año", mes_codigo);
 &   DROP INDEX public.idx_corrida_lookup;
       public            postgres    false    215    215    215    215    215    215            �           1259    43075    idx_corrida_piscina_lookup    INDEX     �   CREATE INDEX idx_corrida_piscina_lookup ON public.corrida_piscina USING btree (cp_num_larv, cp_cos_inv, cp_total_ing, emp_cod, pis_cod, cor_cod);
 .   DROP INDEX public.idx_corrida_piscina_lookup;
       public            postgres    false    217    217    217    217    217    217            �           1259    43103    idx_cosecha_lookup    INDEX     �   CREATE INDEX idx_cosecha_lookup ON public.cosecha USING btree (cos_cant_kg, cos_pre_kg, cos_ing, cor_cod, pis_cod, tal_cod, emp_cod);
 &   DROP INDEX public.idx_cosecha_lookup;
       public            postgres    false    222    222    222    222    222    222    222            �           1259    43099    idx_empresa_lookup    INDEX     |   CREATE INDEX idx_empresa_lookup ON public.empresa USING btree (emp_cod, emp_nom, emp_nom_cam, pais_cod, prov_cod, can_cod);
 &   DROP INDEX public.idx_empresa_lookup;
       public            postgres    false    221    221    221    221    221    221            �           1259    43081    idx_mes_lookup    INDEX     ^   CREATE INDEX idx_mes_lookup ON public.mes USING btree (mes_codigo, mes, trimestre, semestre);
 "   DROP INDEX public.idx_mes_lookup;
       public            postgres    false    218    218    218    218            �           1259    43093    idx_pais_lookup    INDEX     N   CREATE INDEX idx_pais_lookup ON public.pais USING btree (pais_cod, pais_nom);
 #   DROP INDEX public.idx_pais_lookup;
       public            postgres    false    220    220            �           1259    43071    idx_piscina_lookup    INDEX     i   CREATE INDEX idx_piscina_lookup ON public.piscina USING btree (pis_cod, pis_nom, pis_num_hect, emp_cod);
 &   DROP INDEX public.idx_piscina_lookup;
       public            postgres    false    216    216    216    216            �           1259    43087    idx_provincia_lookup    INDEX     b   CREATE INDEX idx_provincia_lookup ON public.provincia USING btree (prov_cod, prov_nom, pais_cod);
 (   DROP INDEX public.idx_provincia_lookup;
       public            postgres    false    219    219    219            �           1259    43109    idx_talla_lookup    INDEX     ]   CREATE INDEX idx_talla_lookup ON public.talla USING btree (tall_cod, tall_nombre, tall_cam);
 $   DROP INDEX public.idx_talla_lookup;
       public            postgres    false    223    223    223            /   R   x�˱
�  ���+��H˰�٭���@������ҭ"z��5�r��%�[T�v�篻�����{���f�l��      0   �   x�}�KN�0E��*�@Pn>v��L��`���:p��*��R�{n����;D� ϓs/��g��l�x�߾���/�6#�2M�_D��ee7G�V8��[��M�lYz`pcT,V'���Z�$��a";��!��;SNc6ذ�%��7ْjKb��ԫ���7{�g~�+;�ҡ��0���*;.�i]�[0H���Y�*L����s=0�1��\�s�&�
�*\ʘ-|�n������<c~�t׫      2      x�E�I�%��CǑ�yG}����:
��?1�L��ARu������_���ƿʿ�ڭ�_��z����G���οV[��G��W�~�5R�Էc�����)�=��������4�*�?�M��Z{jmͱf�1ɿ�Jӯ��������6CMs�6�o�룡U��a�[��;�o�/��W���e�t����w�s���yal�u��;:O�>�f�F�_ͲUg��^���ߵR~WKٰ1�=��d����+�C�����❿�Y��_l��)�Vm�2m��G�f,[i¦�@�m;��}�k���k+�$e6�x]k�{7���MN����í��_���s �vq@�:��i��pZ��w,�ge=�[����N�p���ԂǮl)�M��٩���r~,��u�Ǧ!6۴�ɌE��ƣ��.�jb��קـ*��y1v�]���5a݂��.c�p��Z���6Z�O7"��>Я���:��W��LĦ���Djh�;�3��&G Yj����A��%0 ������~����>��4֯lقG�,Lh3����~<@jl�כ��b4j��yk_��Se����b����	g��H�-݆~���'� `���[��-�dls���;�r�Gm�jza�z�!ʨ;xl`����v21^څ�<�h�p�52����>�km�>�yR3��!G�����+�m`�p�22$Q�X���]��"�j��AsC��h�M�h�4�^���:��6�6���ض��\�Y����
c�G�:��.F��}%�P�}v���	�u�+�$�ąoA��
�%�A��Jlh4j�;T�>��p�؂�W��F��Qc�s��ꨢ�,j�XL�P�i��+V�Ȅޛp�a����a�]�qF��8rl���0��؞����]�.\9c��+�߿s��s���pexa�A�o4b���U������ ��ᱽ}����L6��Ё��!U �s�H{��W�SB�8�R��C�-�������kh�������n4j�Bx�P("�P'��j��h��
AU��
�.]�O�]�����14T)4j�=
n�P�@va�8�/'�IN��B��j^�Z3��5pBH���u%�V#$�%��� Tj�8԰/�y0{#x��i�؎��A�Q�M8���)D�3`���؃=&T���wP��S�ac�c&bc�z<�3ϱj�����5cg'4��֔��K�+����21�\�1݊��F#E�y ��/Q����̳��Y�ƣ�[P�Đ)�������?�Ĕ�4:�;0�dS�����#u;�1��U���Fr}��7����[��� m�!qƕ�u[�tҏh�NvG��ݔ?d�4Npŝе#8�R�|�8_�ݖ���
7�HGY�X
5�h=騱���.?$$Rj�P͔\�%�tE�B��氓"�P*ʝ$�͓H7_0|�ڇ�fQ��Q#�iЬ�(ീQC� �$AK���,j��Y�9R��X�P���p�f�8����$��:��)s�b[~6��]�n�;�p�M|7^wq�mh94l���j�U�9h��;/� n��,��zZ����t�$�ϭ�G'=`\�z]�ID�fvШ��Sh����H�P�FȡB!�k�=LC��T7aZ��֌�
�.���i(j��d~+�)F;!F}5.Y�qʠS��Ǎ�JE!xZ�[���ʾ�ѵ%Dh(bbґ Ay,�����"p���"����O�Q�ݢ�ꢀ�!X�4jh\�-c#*Q�t��* ��Vd���h�눩h�O'M5p�䆝H
��p�(�f���m�Zmv��q��ιG�I0!�e�\��G���v���w�v��q!����S�m�1����%H��=7,���6����-K�R���S1 *�m����C�N�	7��(nr��$T{��f�^��1�F̭<�4�gF�F��D��&�6i_���7����S&��J��#Gm~r'��ʅΓ�/\3%κפ("��&#r�n��_ ��G�D����y��x�Qc}��78SDQ�@r�4ν-��7�HmҎ�ccG� �K�C�Ճp��5`¢�:n �U��9��`3"1�FĖ䑈�H�x`�J�Χ�	�n]��JA�>@򝳋��g�V㑍h����j� �;�8�_ ���ZF�%Q�f����Q����_�sOg-��nn�* ��΋PM���O�?�(��� �P4�F��@�P������z]��52���E'��H<d�'�����r19�5�v�+�|��n�ߓ�7�g<n�z���m�� �'�D���%0�qxRO5�������	�n�@���V�>������{X�=DwZj�*�c.Q�-�{���Jl;H<�)��@Y��F����Sm8+H�&a��8�癁"cęy������`�S2�rR=ï��&W��z����yW~�b�mm�{*������j�53�x���ZA�TT�E�z�\�!L����%?@u]
=S�K��Hk]MY�j0�ym���yq��xq4�V���-N5o$��B[�vrp�a���5���Nd5/�Չ�e�-۞f�XC�M�5�NWx��0o�������`�{v�F�E�
`񾊮�t��5�]@��)�h���r�d�d�V?��%�5W}��i����t.Js>,��Z�/ɖ��]-�MN�~*����](��7��y�M�X!Y���� sS /�P� ��kj����zyA�H�7\əY���ǑmW
޲ry����v)����
b��XL�Yy)$e�BV�R�o�Ԟm;<Ffl��'�dsE�$[q�����r;�.�__&à��J��@�*8'�,�Hu�n�"g�2�(��D���zl �"�9�|�IHO��E�=�,�K�=+v��A<U��D�O�m������q%����l7A�G�||J�'��+r\�N=�i){rv�R��^b�`_�|vO+�b�+�s���)�X�����j��&^H]�?In]�5�1	��E?�4��u�Z^��Ji���w
m�u1��u���p�XS�d��P��Ϊo�;c���\��|g���UI0Ts��X�mѝ��{��"%V9 D(r���vT� ��t���#J[F��j�t,��q��m���v������9/�3�(�RT��|��oO�p��#%����yx6��}er�9T���@����r��zI�0h�q�s��5g�Ö%������[T�
�9���̬�ų��9H$�׻��d9�\R�J]"YO����A/J���45zz$>P�љ��N���I]�.�����܌V@ylJ�D�F�-�8Fe+���䲍��#SwzXWJ�xx��}���Ô)�%=,q�z�S�e�W���,�CۅN��e��@��a�����)��$������s� �%�C˝����6�:�kNJ���	N�QY ��|���]�y����!| ���d(�@�-8mI%�E_��)v���,��]b�}:	l�JO��BD��V�t����K�ᐛ~Q�ʇn�HR���� ����JX,
����������A.��N�K`�(�p���E�멅�������ᱺ�+7;�_��X!á4B��ՇR:1f�봢���aJ�)[��6�Om7Ni��%]R3b�D�0|R�|�h������hB������C�'��&<�����*<��^Rl���)��)"��{�;����v
@%"K;nT��pܔ�����$ݝ~�I�MÑ��+18��Ѣ�N,,�A�%�u^}<���JՌT��xv��>p2p����ww�Fܳ..�����N��'�����ii�s�����\_������֝�Q�ɏ�����BS�M;������Ni���f��>2V>����5@�-��b
5j�7�c���V��T��A���<߉����#L��Ѹ���lq��:4�O��5�)�p��ii5�/���g�ZI�ׇSz#�I�[0m({�n���r1RQ	0j9��]Nr[J���� ���D�~��� �  >u�ɝ�)�PJŮ_E�~�$�KQ�� �i٭ĝ;o��)���Z�� ��@խ@�&�5��>*��=�g2)b���� �\��N��\��� "�� F"�U�v��P���v~w�xc��	bJ���n�P����KA�4jA��3��ҟi.�X�[b��i���\f���Ӧ�<a�媶��޻�<d�5�a=�>�2%U:�ɹ��t?>���"j��h����kuT6<�r��K���1����0�����<�0c�W�]�n<�Q�ܕg[/���;u��M!�A���s�c����"�M��ޖ"U��I>o�Ai���P�eJ�t���D4�,%��A�K�V��v	R��i�)�p�uu�KO�}�7nt!!.�7��_������>��h��׳>7U�v^�{x�޴�Cp/}��gE��;IJ5��;��m��}91�!v��Z�1c�=g���1���w7��F}�t%�pO�� O׏L��\�2�LE�?�������_̧_Rޓ`��x��Na�Iy7�a�M5�@}+��>2e�ŵ� ���q\�����󀊧
N���4����S���RH[��>�<u�����{?�����:Jh�x9�^|B9�/�w#����L����k�g�xP��e�[r�0�m�������<�CEK�G=�|���'a�n?9��N�L��v�>���q��8@��Q����	Re�~����\���M<t2㲴�����]�.�?��O�ԍ��7�֯w�钽���G�������ԫ,�+���.ٜ�0ڿ� 1��:}'W��M�biu��S���=�M�S�(�����8Ni�8�
�e`�����.�v���tS1�	�,����/}�l�*p2����i+�5��.��:B�a���&�<�����:җӉ��%eC�S�� ��˟p&���w���SzCy�1~�j�58�.r��m��m_�]y!v97�SI{�������+�Ł���g�p�LK�8-N�>���7��w T��ރV\|��z�,�q��������W�� ���������{�����ڔ�W�'}��t��%�>M��>-��ė����Ǡ��M_Q��2^Ŕ/�g9(�-O��7��O��0�Z�?CL��:,�^
��NOnc�l�O��CbοRt�]�,��[�Fv�u��=y����9e�ฏw�ID���@\�������S���e��'u�񭠔���J',D��(���moy X��{M��q��2_�O������|�]i�R�M=V�{���Es�g��:/�����R��y�Y��2B���׏l�G�Z	��E��F�M׼��{�yb��D͕�O���Ɲ��:�Y#.?�f����!����������.��[V�EۛI��^�<o���7�"��O�ח|�<u��>���5�@�iKk�l�$�
N�#s��GI>�%����sW-��No��Hx7��m���v���8w�*=�e�֔�&48�Y��	�n�������~������f)/      7      x�MZ[�,�	��^LG	�������P�;aǌ�:�	$��>�3>��#�3���##��y�3~ſ���o�����Ɂ����31��������7��ws�<��+V��S�ƚ����������S��0�0ߙX�����7w[����/���	��9�"�S,��9��{�Q~G�_/��s����?̀�*���l�2��p�11����ő\�~��uJ���Ñ�Efs��[�����{�g�G���\�����'�A��o�"��/}M�J��o��k^do��ă��;w�xa�}����7�Ts���`nm~����)�y3���&�����pO�,��Ő%��X�~�^Y�p��?��������V8��7��ß�7�8=���c�p���s��q�1�zCs�1�0�!@�SX�������p^Y`���Xh=�f/������l{qF����0V��:I����5�;[������8��h=��Ha6���7����G��D�:�3����N�&�5�Oop�'�����\�7^��X�^�n�M�I1�L�#����+l�+�Dk������C��&.���X�m�0�(�Ox)[������W�������!8bpU".��(^���֏F��̓2`G�$q|�k󆱫�>���.�c������Q�1	���a!�k��5Z������0���/&|�%��6�%p\�s><t��p�i�_l봦�%Ǟ4�E/e���	�R��?�>>�",ɝ��qJ^��z��{0����*1��s���mi߃&��k��A����Dp=�f��R��S<�[�_�聄��b�0K�Y���66/F�Y��13�8�М�x���qh4��{ꦛ� ��Mh{𨱴�:�{�����o"!������~)2��X���a�
a��E6Ѽil�.��E��ⴰ/�?&b�h��rf�P�+8������d�
D;-  ��G��`eD�ƊI}����%�̰����l��0ٙL �L`ts2S�!i�U��k���~3�Ig�ó��:����n��Y�5ɑu����[�ʞ�l#���#R0�j���AS�f����IA*6��`�h��Il��T͡�yGz_�<-^Z�����q�"��ٝT'�F� �F��s`j-��k+oH�� p�L�x<"`�H�Gd���~6;B�Ai�1V+���!�@v,�O
d;4���@;�=EP��s���`B�������(��I���$�z�*��9 ��<�jH��&z8��0��H0͑�K%�d�fʉ8�t�;��HwM�1�CxG�"s��6Y���N��AHN,�(���X2,�Jk��K����=x5��t(�ce���CY���GR�I��P�Hd"��Ns�a	/�i��О����ڼ�X�[g�-�I����<;6���^�;�0�pϤ)F	��`7g��gޫ��?D��
 !'��T��R�Q���8B3���F��D|� i�y���'�tpg< ���.� ��6u��9ڄ��4��PR;�Zf(�n�/ݏ�Aq��@jV�>�!�!6E��E#�t��پr9���'��㢃�H�,�p��E�sj�}Y=I��c<��1����eN^N���sh3i�p�'E�F��3)(7A"7.!���V*gR|hиD���N�9YF�>L$4��M����E�3L��4�[&-�*m;�6���Fӥf;�je��n��Kz��h�9Q���0�l�M\6�[ۥ覚2P�5O����Viq��>q��ܞI柢]���-s���c6p��i|1�L�E,��8���Z�J�1�ƻU��&��s�B�����X�]���W����.��Q�sh��,b��<���ne��h���Q�e�nb3>�w���㬂��9r�?�Zy,��#b��Y@!�&-2i�vǠ����x!����l6��2��>%��2���	�P�EJ�'{]^x����~q�(����|��� f�S�8Ssq� *��`ņuQ����l&W�F�;o��%j8�1�3��ar�\���e� ��).��*���#+e�r�#d:�js�E�"1j)�fA��`J���ѷ�>t�G2̋2D�T"ri-ָ2>�*Q�4�`���p�Is��i2�^��Q	� 8*GL��>TaL��G߄��	�\կ���$"����~�
�
���2�*+S:E󤉋�9"L�YԼ OIo�r6��:�S[Ŝ�%T��O��C�⋞�cʕ�Z�1��*`�A�$G2�2��|k��h�2��Pb%�|���hD�(�؋9�8Ry��;����LC{h�E&&`�o:ӈ����<��<�<��W#�-�Su��p�JL���h]��խ���E+����0G�(c����*5�	<���,�$��6�M�-/�JWŸ��U^N�/�]b�$o2B�/Ji�)�,T|;���J[
��Mqu�?�7}i?�P{-����QS�)�����Y�1pUL�O��2�#�l�RJ�$���j��"�u���A�F˄��TF߱�����;�F&Ux��qS����5mΒ\�\-c��$*K�TC��M�y��^�ɶ�c9�w_�M�.���"�_B�(3z֠S��	՛�y.�C�)����i�j�ܔ�D�!6%(B#�,l	T�t�f�� A>B��aU�B&�ᨇ��@�3��B*�ȣ��:�.�nsK��ޙ�9ԮRQ�Qr�-�hF+Z��Qr!�.�S�$˕�'5��F2.�� K%y�_ _���I���� X��M�@���dA3�d�aTz�j��-|+�K�;��ym��� fE��Q
�¢i�JR��Gt�a�/ e���5��#����3B�V����P��X�HK������B��t�d��k�x�� ��Cc�]��c���!�-[�����}.��T�-[b��^��)W��`۶�z`��!�YF�1�����>f+՜c��cI$L�~���u�Y����:�J{�_����8��*���HI��q=`}�<�U���-�(�*��Dy�"v\�6S0��-K�L'���k��9�J߽��@���s�jN��J����?Ͼh�k���<ZG����?����ۋ�!���Jj#^ T!!���qE^A��rśax�l=���^�Nk÷v`�ۢ8�!v�]�'&�%�(��=��-t�|���;[�}#�l�k�$�x�����l*�[��T.�K�i�G�X�=.dZ�$�Pu'P��zߐ�O�۹����`���cm銮EH�v�i-���@��5w��L}Ҝ��s/�r��kF'0��e���9^ȅ>���R�/�0"���T��o�V�e�ȉ�%�/'���G��D�&'��i}Cq�Y��$ʆb�?tAC=Jc{�����@T�$T���HN�,T���H��Ǣ�R}�j�Rp��/�P����Vu(�I�;Y�kH�����.I��wa�N��v�P=��_�;ҖԸ;ǽ9kq�7�6H�r���Rq�D7P�"�6��9�X��V�_[a�F%�珰P˾����������X��8��u3��e�J`��%(	�Ԑ�X�S�:��&ȗպ%���,ފI��(&Z�x���c[7㶸�}Tg_�_�JO�9��n�R[����H���X��\�\r�2�r"']w��&Q�V���nE��m��C��_�-�Rb<�\�
t��'xI�Da�ٹ�aG�%k�Q��:��ΘCI}���J8��îWk��+O.�I�C�ס^�n����K[�ԏ���U=��W��e���)����J��-�{�5L1?�7�5�'��f��3`Wk�8��x"ۣ�Ze�ԛA�����)�������az~3�$Su{!�	��zJ����p9ou��)��c�J
�M�����׼M'ͷ���j�i�A�y�p%A��o��;�t����T��!ϙ���S�y��"x�Vd&T��0c;Q_i����Nu�\��NB��z��n�KJ]���e��1��r�� ��� >  P�;�
�6M��ms�����e!|�`�5�;�eWs��	�8�	/�i��8R_%��7��L���nZ��e~\ɹ��������u�mSl������Fu��h�����;o�0�'jD�G�ǌ����ʽ��sEEdwWP�Ǣ�|�����h����IҢ�n���pQA����Ƌ݂�LQ�+{�iu�*���V
R��w��R�%Nʮ�����ۢI���F޷H�իd�=mC�(�)�K5�U]�x�1-�۱С�����o�ˆ��~@�oQ�����}y�5�R8�g�(}H����!�������p$���RH,W_R\�8`��.]� [|�.�J^�ޗoU7?�����G^���D*?^ٻ|���r�'��cd��v�����B� T�^E�b?uy�i�Ng�A�E!�%�J���GZ����[�1�P=�bo�[�~#i�o�}���N�<]@L+ݔ���`n��)\H{����w?#a�*G��e�o[���<T�&��+dO6T�Yy7n��6�vc�;Zp�r1�U���ż c�,n���oK������s��M�N���� ��F�V���m�%]N�^��o�?�҈�{���T��_���>`��Ǜ����$
�.����a�!-�<R�Cؼ��]R�Z�\����¦ �������]�^�a��s3�GV�L�մ{H��4���^������Dd�ݔ�u��1N�����_n
{b��	�w�A��i��K� 3=� ��_b�� )|ʍ�زm<Wk{ԯ�����սs�U+K��۠�/�ǹ�G�JK]އ@��72L�L�����?7�T�b�a޶Y�BǗ1(��@�/f���x.�K*T�%��'����kJ]�G�M� Iw��Ux�!�3V��f���՛c�F�_����x�O�҈%��8�`F�v-=��Ǩ *k��6�'"O����D�<\zߵE��zN����̎K���3�) �~e�7wqe�Y������a��Ҩ�[�N̙���=��B�]�u�,pފ��Cl�Ű��j?& m���}zln?;�;l7:��5����?*ʣ���Ǜ�ݴ������A�D�      6   �   x�-�A� ��W���!!J�+�"$��"���(I+|�� ;kax�E1\"�M[�nQ%1n�:,4"�E��\����4!�7��J�{=[�Fr�CŬ!����s���>�����8�z/�E�F9.��1$����9�<��_M+=      3   �   x�3�t�K-��1�6�2�tKM*B��9}��`<NǤ���#�(W��qz��e�x�@^�g�l�e�阞_\�Zr��d��-�
p�'���L���~�e05!#N��d�=... _0�      5   1   x�3�tM.ML�/�2�H-*�2�t����M�L�2�t���I����� ��)      1   �   x�%���0C��.)�����$ޢ��Q��| )�d��LN1ujk����pMYQ����P�� $ۓ�]OY�۩��N�r8�f�9c��@A�m����/����Y&��+���0a4��F
�J?�C{5n���Q����w��Y�������ml/6      4   J   x�3�t�Q�/��4�2��M�KL:��6����M�4���,-�,9��2o��4�24j+,��4����� �=/      8   �   x�M�A�0E�N�	�NK.+4ZT�&.��g�b6
	����� <��W]���,�4v����R�V�y<%�c���OZX[rk�<��Ў��+ac����T�3�kE��Z�*���+�
ʶ�'�pS��-�s����1N�/y�h����:���3�     