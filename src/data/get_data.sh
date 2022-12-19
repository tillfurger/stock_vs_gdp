#! /bin/bash/
docker run -e RESEARCH_DATA_PATH=$RESEARCH_DATA_PATH -e API_KEY=$ALPHA_VANTAGE_API_KEY -e FRED_API_KEY=$FRED_API_KEY --rm -v `pwd`:/proj_home stock_vs_gdp_data