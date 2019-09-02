FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app

# Copy project files and restore
FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY SimpleApi/*.csproj  SimpleApi/
RUN dotnet restore SimpleApi/SimpleApi.csproj

# Copy everything and run build
COPY SimpleApi/. SimpleApi/
WORKDIR /src/SimpleApi
RUN dotnet build SimpleApi.csproj -c Release -o /app

# Publish runtime artifacts 
FROM build AS publish
RUN dotnet publish SimpleApi.csproj -c Release -o /app

# Create final runtime image
FROM base AS final
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SimpleApi.dll"]