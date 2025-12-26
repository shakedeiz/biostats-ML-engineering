# 1. Base Image: Linux + R + Tidyverse
FROM rocker/tidyverse:4.2.0

# 2. Install System Libraries (Linux tools needed for GIFs)
RUN apt-get update && apt-get install -y \
    cargo \
    libsodium-dev \
    libmagick++-dev \
    libavfilter-dev

# 3. Install R Packages
# We install these directly into the image
RUN R -e "install.packages(c('gganimate', 'gifski', 'ggrepel', 'scales', 'broom'), repos='http://cran.rstudio.com/')"

# 4. Set up the workspace
WORKDIR /app
COPY . /app

# 5. Default Command
CMD ["Rscript", "production_pipeline.R"]