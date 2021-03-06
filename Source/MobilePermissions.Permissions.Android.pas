unit MobilePermissions.Permissions.Android;

interface

uses
  {$IF CompilerVersion >= 33.0}
  System.Permissions,
  {$ENDIF}
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  Androidapi.JNI.JavaTypes,
  {$ENDIF}
  System.Character,
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  MobilePermissions.Permissions.Base,
  MobilePermissions.Permissions.Interfaces;

type TMobilePermissionsAndroid = class(TMobilePermissionsBase, IMobilePermissions)
  private
    FAndroidVersion : Integer;

    procedure SetAndroidVersion;

    procedure RequestPermissionsResultProc(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
  public
    function Request(Permissions: TArray<string>): IMobilePermissions; override;

    constructor create;
    destructor  Destroy; override;
end;

implementation

{ TMobilePermissionsAndroid }

constructor TMobilePermissionsAndroid.create;
begin
  FAndroidVersion := 0;
end;

destructor TMobilePermissionsAndroid.Destroy;
begin
  inherited;
end;

procedure TMobilePermissionsAndroid.SetAndroidVersion;
{$IFDEF ANDROID}
var
  VersionOSStr : String;
  MajorVersion : string;
  i            : Integer;
{$ENDIF}
begin
  if FAndroidVersion = 0 then
  begin
    {$IFDEF ANDROID}
    VersionOSStr := JStringToString(TJBuild_VERSION.JavaClass.RELEASE);

    for i := 0 to Pred(VersionOSStr.Length) do
    begin
      if not (VersionOSStr[i].IsNumber) then
        Break;

      MajorVersion := MajorVersion + VersionOSStr[i];
    end;

    FAndroidVersion := StrToInt(MajorVersion);
    {$ENDIF}
  end;
end;

function TMobilePermissionsAndroid.Request(Permissions: TArray<string>): IMobilePermissions;
begin
  result := Self;
  SetAndroidVersion;
  {$IF CompilerVersion >= 33.0}
  if (FAndroidVersion > 6) then
    PermissionsService.RequestPermissions(Permissions, RequestPermissionsResultProc, nil);
  {$ENDIF}
end;

procedure TMobilePermissionsAndroid.RequestPermissionsResultProc(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
begin
  if Assigned(FOnRequest) then
    FOnRequest(nil);
end;

end.
