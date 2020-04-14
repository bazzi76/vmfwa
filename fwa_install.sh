SCRIPTPATH=$(pwd)
DOCKER=$(which docker)
BUNZIP2=$(which bunzip2)
TAR=$(which tar)

if [ ! -f "$DOCKER" ]; then
            echo "Docker non installato"
            exit 1
    fi

if [ ! -f "$BUNZIP2" ]; then
            echo "bunzip2 non installato"
            exit 1
    fi

if [ ! -f "$TAR" ]; then
            echo "tar non trovato"
            exit 1
    fi

if [ ! -f "$DOCKER" ]; then
            echo "Docker non installato"
            exit 1
    fi
#exit 0


$BUNZIP2 COVMAP.tar.bz2
$TAR xvf COVMAP.tar

$DOCKER volume create --name ViewMetrixCovMap

$DOCKER run -it -d --rm --name fwadatatmp --mount source=ViewMetrixCovMap,target=/mnt/volume2 alpine
cd COVMAP
$DOCKER cp . fwadatatmp:/mnt/volume2
$DOCKER stop fwadatatmp
cd ..
$DOCKER import viewmfwa.tar.gz viewmetrixtemp
mkdir tmp ; cd tmp ; cp ../Dockerfile .
$DOCKER build -t viewmetrixfwa -f ./Dockerfile .
$DOCKER rmi viewmetrixtemp
$DOCKER run -it -d -P --name view_metrix_fwa --mount source=ViewMetrixCovMap,target=/var/www/TI/ViewMetrixGui/backend/COVMAP viewmetrixfwa

echo "Tutto finito"


