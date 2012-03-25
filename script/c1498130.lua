--六武衆の影武者
function c1498130.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1498130,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1498130.tgcon)
	e1:SetOperation(c1498130.tgop)
	c:RegisterEffect(e1)
end
function c1498130.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tg=g:GetFirst()
	local c=e:GetHandler()
	if tg==c or tg:GetControler()~=tp or tg:IsFacedown() or not tg:IsLocation(LOCATION_MZONE) or not tg:IsSetCard(0x3d) then return false end
	local tf=re:GetTarget()
	return tf(re,rp,nil,nil,nil,nil,nil,nil,0,c)
end
function c1498130.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Group.CreateGroup()
		g:AddCard(c)
		Duel.ChangeTargetCard(ev,g)
	end
end
