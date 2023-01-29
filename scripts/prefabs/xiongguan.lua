local assets =
{
    Asset("ANIM", "anim/xiongguan.zip"),
    Asset("ANIM", "anim/xiongguan_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/xiongguan.xml"),
    Asset("IMAGE", "images/inventoryimages/xiongguan.tex"),
}

local function UpdateDamage(inst)
    local wdamage = 68

    if inst.components.perishable and inst.components.weapon then
        local dmg = wdamage * inst.components.perishable:GetPercent()
        dmg = Remap(dmg, 0, wdamage, TUNING.HAMBAT_MIN_DAMAGE_MODIFIER*wdamage, wdamage)
        inst.components.weapon:SetDamage(dmg)
    end
end

local function onequip(inst, owner) 
    UpdateDamage(inst)
    owner.AnimState:OverrideSymbol("swap_object","xiongguan_sw","xiongguan")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 

    owner.components.talker:Say("Valhallaaaaa!")
end

local function onunequip(inst, owner)
    UpdateDamage(inst)
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end
	
local function onattack(inst, owner, target)
    UpdateDamage(inst)
end

local function beagerstick_oneatfn(inst, food)
    local health = math.abs(food.components.edible:GetHealth(inst)) * inst.components.eater.healthabsorption
    local hunger = math.abs(food.components.edible:GetHunger(inst)) * inst.components.eater.hungerabsorption
    inst.components.perishable:AddTime(health + hunger*10)

    if not inst.inlimbo then
        inst.AnimState:PlayAnimation("eat")
        inst.AnimState:PushAnimation("anim", true)

        inst.SoundEmitter:PlaySound("terraria1/eyemask/eat")
    end

    -- speach when eat
    local foodtype = food.components.edible.foodtype
    inst.components.talker:Say("I eat "..tostring(foodtype)..", nom nom nom!")
end
	
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("xiongguan")
    inst.AnimState:SetBuild("xiongguan")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --eater (from eater component) added to pristine state for optimization
    inst:AddTag("handfed")
    inst:AddTag("fedbyall")
    inst:AddTag("eatsrawmeat")
    inst:AddTag("strongstomach")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    local swap_data = {sym_build = "swap_xiongguan", bank = "xiongguan"}
    MakeInventoryFloatable(inst, "med", nil, {1.0, 0.5, 1.0}, true, -13, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement="spoiled_food"

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER, 2)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetOnAttack(onattack)

    -- To play an eat sound when it's on the ground and fed.
    inst.entity:AddSoundEmitter()

    inst:AddComponent("eater")
    inst.components.eater:SetOnEatFn(beagerstick_oneatfn)
    inst.components.eater:SetAbsorptionModifiers(4.0, 1.75, 0)
    inst.components.eater:SetCanEatRawMeat(true)
    inst.components.eater:SetStrongStomach(true)
    inst.components.eater:SetCanEatHorrible(true)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/xiongguan.xml"

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 28
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(.9, .4, .4)
    inst.components.talker.offset = Vector3(0, 0, 0)
    inst.components.talker.symbol = "swap_object"

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

    return inst

    -- local inst = CreateEntity()

    -- inst.entity:AddTransform()
    -- inst.entity:AddAnimState()
    -- inst.entity:AddNetwork()
    -- MakeInventoryPhysics(inst)

    -- inst.entity:SetPristine()
	-- inst.entity:AddMiniMapEntity()
    -- inst.MiniMapEntity:SetIcon("xiongguan.tex")

    -- inst.AnimState:SetBank("xiongguan")
    -- inst.AnimState:SetBuild("xiongguan")
    -- inst.AnimState:PlayAnimation("idle")

    -- inst:AddTag("sharp")

    -- inst:AddComponent("tool")
    -- inst.components.tool:SetAction(ACTIONS.HAMMER, 2)
   	
    -- inst:AddComponent("weapon")
	-- inst.components.weapon:SetOnAttack(onattack)
    -- inst.components.weapon:SetDamage(68)
    -- inst.components.weapon:SetRange(1,2)
	
	-- inst:AddComponent("combat")
    -- inst.components.combat:SetDefaultDamage(15000)
    -- inst.components.combat.playerdamagepercent = 0

    -- inst:AddComponent("inspectable")
	
    -- inst:AddComponent("fueled")
    -- inst.components.fueled:InitializeFuelLevel(180)
	-- inst.components.fueled.fueltype = "NIGHTMARE"
	-- inst.components.fueled.accepting = true

    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(20000)
    -- inst.components.finiteuses:SetUses(20000)   
    -- inst.components.finiteuses:SetOnFinished( onfinished )
    
    -- inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/xiongguan.xml"
	
	-- inst:AddComponent("insulator")
    -- inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
    
    -- inst:AddComponent("equippable")
    -- inst.components.equippable:SetOnEquip( onequip )
    -- inst.components.equippable:SetOnUnequip( onunequip )
	-- inst.components.equippable.walkspeedmult = 1.8
    -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE	
    -- return inst
end

return Prefab("xiongguan", fn, assets, prefabs)


