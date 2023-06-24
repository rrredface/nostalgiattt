-- just adds some cvars and overrides some existing functions to make them use
-- those cvars

-- these all default to vanilla behavior
local charge_force_fwd_min = CreateConVar("ttt_newton_force_fwd_min", "300")
local charge_force_fwd_max = CreateConVar("ttt_newton_force_fwd_max", "700")
local charge_force_up_min = CreateConVar("ttt_newton_force_up_min", "100")
local charge_force_up_max = CreateConVar("ttt_newton_force_up_max", "350")
local base_force_fwd = CreateConVar("ttt_newton_force_fwd_base", "600")
local base_force_up = CreateConVar("ttt_newton_force_up_base", "300")
local enable_double_shot = CreateConVar("ttt_newton_allow_doubleshot", "0")


local function PrimaryAttack(self)
   if self.IsCharging and (not enable_double_shot:GetBool()) then return end

   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

   self:FirePulse(base_force_fwd:GetInt(), base_force_up:GetInt())
end

local function ChargedAttack(self)
   local charge = math.Clamp(self:GetCharge(), 0, 1)

   self.IsCharging = false
   self:SetCharge(0)

   if charge <= 0 then return end

   local max = charge_force_fwd_max:GetInt()
   local diff = max - charge_force_fwd_min:GetInt()

   local force_fwd = ((charge * diff) - diff) + max

   max = charge_force_up_max:GetInt()
   diff = max - charge_force_up_min:GetInt()

   local force_up = ((charge * diff) - diff) + max

   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

   self:FirePulse(force_fwd, force_up)
end

if GAMEMODE then
	local newton = weapons.GetStored("weapon_ttt_push")
	newton.PrimaryAttack = PrimaryAttack
	newton.ChargedAttack = ChargedAttack
end

hook.Add("OnGamemodeLoaded", "nost_newton_cvars", function ()
	local newton = weapons.GetStored("weapon_ttt_push")
	newton.PrimaryAttack = PrimaryAttack
	newton.ChargedAttack = ChargedAttack
end)
