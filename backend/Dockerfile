# Use the official Microsoft ASP.NET Core runtime image (.NET 9)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["AppFactory.Backend.csproj", "."]
RUN dotnet restore "./AppFactory.Backend.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AppFactory.Backend.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AppFactory.Backend.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Generate final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AppFactory.Backend.dll"]
